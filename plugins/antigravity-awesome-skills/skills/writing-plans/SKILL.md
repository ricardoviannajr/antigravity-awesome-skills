---
name: writing-plans
description: 'Pós-Brainstorm: Transforma o design em um plano de execução de tarefas
  ''bite-sized'' (2-5 min) com caminhos de arquivos exatos.'
risk: safe
source: obra/superpowers
date_added: '2026-05-16'
---
# 📝 Writing Plans (Planejamento de Execução)

Esta skill é ativada após o design ser aprovado. Ela quebra o trabalho em tarefas pequenas o suficiente para que um engenheiro júnior entusiasta possa seguir sem errar.

## 📋 Checklist de Planejamento
Você deve criar uma tarefa para cada item e seguir a ordem:

1. **Análise de Dependências:** Identificar o que precisa ser construído primeiro.
2. **Quebra de Tarefas:** Cada tarefa deve levar no máximo 5 minutos de codificação.
3. **Caminhos Exatos:** Especificar os caminhos completos dos arquivos para cada tarefa.
4. **Verificação por Tarefa:** Cada item do plano deve ter um comando de teste ou critério de verificação.

## 📐 Estrutura do Plano
O plano deve ser salvo no arquivo `task.md` (ou injetado no sistema de tracking atual) com este formato:

- `[ ]` **Tarefa 1:** Descrição curta e técnica.
    - **Arquivos:** `src/components/Search.js`
    - **Ação:** Criar componente base com input.
    - **Verificação:** `npm test Search`
- `[ ]` **Tarefa 2:** Próximo passo atômico...

## 🛑 Regras de Ouro
*   **Atomicidade:** Se uma tarefa parece "grande", quebre-a em duas.
*   **Contexto Zero:** Escreva a tarefa como se quem fosse executar não soubesse nada do brainstorm (inclua o "porquê" técnico).
*   **TDD First:** A primeira subtarefa de cada item técnico deve ser sempre a criação do teste falho.

---
*Plano concluído. Próximo passo: Execução com TDD.*
