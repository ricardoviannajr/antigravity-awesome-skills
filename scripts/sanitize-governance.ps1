# .SYNOPSIS
#   Higienização de governança para consolidar a raiz como Fonte de Verdade.
#
# .DESCRIPTION
#   Remove stubs e move os arquivos reais de antigravity/ para a raiz de cada projeto.
#   Garante que não existam arquivos repetidos e que a raiz seja limpa e funcional.

$ProjectsRoot = "C:\Users\ricar\Documents\# Projetos Antigravity"
$AIConfigRoot = Join-Path $ProjectsRoot "AIConfig"

Write-Host "Iniciando HigienizaÃ§Ã£o de GovernanÃ§a (Root Consolidation)..." -ForegroundColor Cyan

$Projects = Get-ChildItem -Path $ProjectsRoot -Directory | Where-Object { 
    (Test-Path (Join-Path $_.FullName ".git")) -or (Test-Path (Join-Path $_.FullName "AGENTS.md"))
}

foreach ($Project in $Projects) {
    $ProjectPath = $Project.FullName
    Write-Host "Higienizando: $($Project.Name)..." -ForegroundColor Gray

    $AntigravityDir = Join-Path $ProjectPath "antigravity"
    $FilesToConsolidate = @("GEMINI.md", "AGENTS.md", "SKILLS.md", "walkthrough.md")

    foreach ($File in $FilesToConsolidate) {
        $Source = Join-Path $AntigravityDir $File
        $Dest = Join-Path $ProjectPath $File

        if (Test-Path $Source) {
            Write-Host "  [>] Movendo $File para a raiz..." -ForegroundColor Green
            Move-Item -Path $Source -Destination $Dest -Force
        }
    }

    # Remover arquivos repetidos residuais se existirem na pasta antigravity
    # (scripts, rules e skills/ permanecem lá)
    
    # Git Sync para consolidar a mudanÃ§a
    if (Test-Path (Join-Path $ProjectPath ".git")) {
        git -C $ProjectPath add .
        git -C $ProjectPath commit -m "[Log: Governance Hygiene - Root Consolidation]" --allow-empty
        git -C $ProjectPath push origin master -ErrorAction SilentlyContinue
    }
}

Write-Host "HigienizaÃ§Ã£o concluÃ­da!" -ForegroundColor Green
