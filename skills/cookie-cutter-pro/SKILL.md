---
name: cookie-cutter-pro
description: "Transforma imagens, logotipos e mandalas em modelos STL 3D de cortadores de biscoito de alta fidelidade prontos para impressão FDM."
---

# Cookie Cutter Pro (Premium Version)

Este módulo contém a especificação técnica e as instruções de integração da Skill **Cookie Cutter Pro (Versão Premium)**. Esta versão utiliza a lógica de modelagem de Alta Fidelidade, garantindo resultados profissionais para impressão 3D FDM.

## Intent Mapping (Gatilhos de Linguagem Natural)

A inteligência de processamento de linguagem natural (NLU) do core da Antigravity interceptará as seguintes intenções para acionar este microsserviço:

- "Transforme essa imagem em um cortador de biscoitos"
- "Gere o STL de cortador para esta mandala"
- "Crie um kit premium de cortador de 60mm usando este logo"
- "Fatie essa imagem para impressão 3D de cortador"

## Execução (Worker Core)

O processamento geométrico é feito através do script `generate_cutter_set.py`.

## Diretrizes da Interface de Resposta UI

Quando o pipeline concluir a geração com sucesso, a interface conversacional da Antigravity deverá responder utilizando o padrão abaixo para consistência visual:

> 🍪 Seu Kit de Cortador Premium Está Pronto!
> O processamento de alta fidelidade aplicou os padrões de engenharia 3D. O arquivo STL único contém as três peças posicionadas para impressão direta sem suportes.
> 
> **Diâmetro Configurado**: 60mm (com tolerância de encaixe adaptativa de 0.5mm).
> **Resolução de Camada Alvo**: 0.2mm.
> **Perfil de Corte**: Lâmina de 1.2mm com reforço estrutural de base.
> 
> 💾 [Fazer Download do Arquivo STL Gerado]
> 
> 🖨️ **Recomendações de Impressão e Manutenção**
> - **Material Recomendado**: PLA (de preferência grau alimentício ou impermeabilizado).
> - **Fatiamento Crítico**: Configure a altura da camada estritamente para 0.2mm com no mínimo 3 perímetros de parede para reforço da lâmina de corte.
> - **Pós-Processamento**: Fixe a alça ergonômica no furo traseiro do carimbo utilizando uma gota de cianoacrilato.
> - **Higienização**: Lave apenas com água fria e sabão neutro. O PLA deforma facilmente sob temperaturas superiores a 50°C (não utilizar máquina de lavar louça).
