---
name: brainstorming
description: Use antes de qualquer trabalho criativo (features, arquitetura, comportamento).
  Transforma ideias vagas em designs validados via diálogo socrático.
risk: safe
source: obra/superpowers + Antigravity
date_added: '2026-05-16'
---
# 🧠 Brainstorming: Do Caos ao Design

Esta skill transforma ideias brutas em especificações claras e validadas **antes** de qualquer implementação.

<HARD-GATE>
Você NÃO está autorizado a escrever código, criar pastas de projeto ou realizar qualquer implementação enquanto esta skill estiver ativa.
</HARD-GATE>

## 🎭 Modo de Operação: Facilitador Socrático
Seu objetivo é extrair a essência do projeto através de um diálogo natural, porém disciplinado.

1. **Entenda o Contexto:** Leia `MEMORIA.md`, `CORE.md` e arquivos relevantes.
2. **Uma Pergunta por Vez:** Nunca envie uma lista de perguntas. Pergunte uma coisa, entenda a resposta, e siga para a próxima.
3. **Múltipla Escolha:** Prefira dar opções ao usuário para acelerar a decisão.

## 📋 Checklist Obrigatório
Você deve completar estes itens em ordem:

1.  **Explorar Contexto:** Verificar arquivos, docs e decisões anteriores.
2.  **Perguntas de Esclarecimento:** Uma por vez, focando em propósito, restrições e critérios de sucesso.
3.  **Propor 2-3 Abordagens:** Apresentar caminhos técnicos diferentes com prós e contras.
4.  **Apresentar o Design:** Em seções curtas (200-300 palavras), pedindo aprovação após cada seção.
5.  **Escrever Spec Doc:** Salvar em `docs/specs/YYYY-MM-DD-<topic>-design.md` e commit.
6.  **Handoff:** Invocar obrigatoriamente a skill `writing-plans` para iniciar a fase de execução.

## 📐 Princípios de Design
*   **YAGNI (You Aren't Gonna Need It):** Remova funcionalidades desnecessárias.
*   **KISS (Keep It Simple, Stupid):** A simplicidade é o objetivo primário.
*   **Isolamento:** Desenhe componentes que possam ser testados de forma independente.

## 🛑 Condição de Saída
Você só pode sair do modo de brainstorm quando:
*   O design foi validado e aprovado pelo usuário.
*   O documento de especificação foi commitado.
*   **Você invocou a skill `writing-plans`.**

---
*Fim do Brainstorm. Próximo passo: Planejamento de Execução.*
ons, safety boundaries, or success criteria are missing.