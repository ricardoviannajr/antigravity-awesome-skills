import cv2
import numpy as np
import trimesh
from shapely.geometry import Polygon, MultiPolygon
from shapely.ops import unary_union
from shapely.affinity import scale, translate
import argparse

def generate_premium_kit(image_path, output_path, max_diameter_mm=60, wall_h=10, relief_h=3, layer_res=0.2):
    """
    Gera o Kit Premium (Alta Fidelidade):
    - Resolução rigorosa de 0.2mm em todas as camadas
    - Diâmetro máximo de 60mm (incluindo reforço)
    - Cunha interna agressiva e visível
    - Chanfro externo de alta precisão
    - Alça invertida para impressão sem suportes
    """
    # 1. Processamento de Imagem
    img = cv2.imread(image_path)
    if img is None:
        raise ValueError("Erro: Imagem não encontrada no caminho especificado.")
        
    # Super-resolução para processamento de contornos
    scale_up = 4
    img_large = cv2.resize(img, (img.shape[1]*scale_up, img.shape[0]*scale_up), interpolation=cv2.INTER_CUBIC)
    gray = cv2.cvtColor(img_large, cv2.COLOR_BGR2GRAY)
    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)
        
    # 2. Extrair Contornos de Alta Precisão
    contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_TC89_L1)
    polygons = []
    for i in range(len(contours)):
        if hierarchy[0][i][3] == -1: # Contorno externo (pai)
            poly = Polygon(contours[i].reshape(-1, 2))
            if not poly.is_valid: poly = poly.buffer(0)
                        
            # Subtrair furos (filhos)
            children = [j for j, h in enumerate(hierarchy[0]) if h[3] == i]
            for child_idx in children:
                child_poly = Polygon(contours[child_idx].reshape(-1, 2))
                if not child_poly.is_valid: child_poly = child_poly.buffer(0)
                poly = poly.difference(child_poly)
            polygons.append(poly)
    mandala_lines = unary_union(polygons)
        
    # 3. Ajuste de Diâmetro Rigoroso (Limite de 60mm)
    if isinstance(mandala_lines, MultiPolygon):
        outer_poly = unary_union([Polygon(p.exterior) for p in mandala_lines.geoms])
    else:
        outer_poly = Polygon(mandala_lines.exterior)
            
    # Centralizar a geometria
    minx, miny, maxx, maxy = outer_poly.bounds
    mandala_lines = translate(mandala_lines, -minx - (maxx-minx)/2, -miny - (maxy-miny)/2)
    outer_poly = translate(outer_poly, -minx - (maxx-minx)/2, -miny - (maxy-miny)/2)
        
    # Calcular escala para diâmetro final de 60mm (considerando 4mm de reforço/parede)
    current_max_dim = max(outer_poly.buffer(4.0).bounds[2] - outer_poly.buffer(4.0).bounds[0],
                          outer_poly.buffer(4.0).bounds[3] - outer_poly.buffer(4.0).bounds[1])
    s = max_diameter_mm / current_max_dim
    mandala_lines = scale(mandala_lines, s, s, origin=(0,0))
    outer_poly = scale(outer_poly, s, s, origin=(0,0))
        
    all_meshes = []
    
    # --- PEÇA 1: CORTADOR (ORIENTAÇÃO INVERTIDA) ---
    wall_steps = int(wall_h / layer_res)
    for i in range(wall_steps):
        z = i * layer_res
        t = i / (wall_steps - 1)
        # Chanfro: Base 2.0mm -> Topo 1.2mm
        thickness = 2.0 - (t * 0.8) 
        layer_wall = outer_poly.buffer(thickness).difference(outer_poly)
                
        # Reforço de 2mm na base da impressão (topo do cortador)
        if z < 5.0:
            layer_wall = outer_poly.buffer(thickness + 2.0).difference(outer_poly)
                    
        if not layer_wall.is_empty:
            if isinstance(layer_wall, MultiPolygon):
                for p in layer_wall.geoms:
                    m = trimesh.creation.extrude_polygon(p, layer_res)
                    m.apply_translation([0, 0, z])
                    all_meshes.append(m)
            else:
                m = trimesh.creation.extrude_polygon(layer_wall, layer_res)
                m.apply_translation([0, 0, z])
                all_meshes.append(m)
                
    # --- PEÇA 2: CARIMBO (ALTA RESOLUÇÃO) ---
    stamp_lines = mandala_lines.buffer(-0.5) # Folga de encaixe
    stamp_outer = outer_poly.buffer(-0.5)
    stamp_offset_x = 75.0 # Espaçamento no STL
        
    # Fundo Sólido (1.5mm) com Furo para Alça
    base_h = 1.5
    handle_hole_radius = 2.5
    handle_hole_poly = Polygon([(handle_hole_radius * np.cos(a), handle_hole_radius * np.sin(a)) for a in np.linspace(0, 2*np.pi, 32)])
    base_mesh = trimesh.creation.extrude_polygon(stamp_outer.difference(handle_hole_poly), base_h)
    base_mesh.apply_translation([stamp_offset_x, 0, 0])
    all_meshes.append(base_mesh)
        
    # Relevo em Cunha (3mm de altura)
    relief_steps = int(relief_h / layer_res)
    for i in range(relief_steps):
        z = i * layer_res
        t = i / (relief_steps - 1)
        # Cunha: Base larga -> Topo de 1mm (0.3mm de buffer cada lado)
        shrink = 0.3 - (t * 0.3)
        layer_relief = stamp_lines.buffer(shrink)
                
        if not layer_relief.is_empty:
            if isinstance(layer_relief, MultiPolygon):
                for p in layer_relief.geoms:
                    m = trimesh.creation.extrude_polygon(p, layer_res)
                    m.apply_translation([stamp_offset_x, 0, base_h + z])
                    all_meshes.append(m)
            else:
                m = trimesh.creation.extrude_polygon(layer_relief, layer_res)
                m.apply_translation([stamp_offset_x, 0, base_h + z])
                all_meshes.append(m)
                
    # --- PEÇA 3: ALÇA ERGONÔMICA (INVERTIDA) ---
    handle_offset_y = 75.0
    # Corpo da alça (base na mesa Z=0)
    handle_base = trimesh.creation.cylinder(radius=7.5, height=15.0, sections=64)
    handle_base.apply_translation([stamp_offset_x, handle_offset_y, 7.5])
    all_meshes.append(handle_base)
        
    # Pino de encaixe (no topo da impressão Z=15)
    pin_mesh = trimesh.creation.cylinder(radius=2.4, height=1.5, sections=32)
    pin_mesh.apply_translation([stamp_offset_x, handle_offset_y, 15.0 + 0.75])
    all_meshes.append(pin_mesh)
    
    # 4. Finalização e Exportação
    final_mesh = trimesh.util.concatenate(all_meshes)
    final_mesh.fix_normals()
    final_mesh.merge_vertices()
    final_mesh.export(output_path)
    return len(final_mesh.faces)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Gerador Antigravity de Cortador de Biscoito")
    parser.add_argument("image", help="Caminho da imagem de entrada")
    parser.add_argument("output", help="Caminho do arquivo STL de saída")
    parser.add_argument("--diameter", type=float, default=60, help="Diâmetro em mm")
    args = parser.parse_args()
    
    try:
        faces = generate_premium_kit(args.image, args.output, max_diameter_mm=args.diameter)
        print(f"SUCCESS|{faces}")
    except Exception as e:
        print(f"ERROR|{str(e)}")
