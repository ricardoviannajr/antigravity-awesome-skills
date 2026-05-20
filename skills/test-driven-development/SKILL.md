---
name: test-driven-development
description: "EXECUÇÃO: Impõe o ciclo Red-Green-Refactor. Proíbe a escrita de código de produção antes do teste falho."
risk: low
source: obra/superpowers
date_added: "2026-05-16"
---

# 🧪 Test-Driven Development (TDD)

Esta skill garante a integridade do código através do ciclo disciplinado de testes.

## 🔄 O Ciclo Red-Green-Refactor

### 1. 🔴 RED (Falha)
*   Escreva o teste **mínimo** para a funcionalidade desejada.
*   Execute o teste e veja-o falhar (garanta que falhou pelo motivo certo).
*   **Atenção:** Se o teste passar de primeira, algo está errado (ou a lógica já existe, ou o teste é inválido).

### 2. 🟢 GREEN (Sucesso)
*   Escreva o código **mínimo necessário** para fazer o teste passar.
*   Não tente ser elegante agora; apenas faça o teste ficar verde.
*   Não adicione funcionalidades extras (YAGNI).

### 3. 🔵 REFACTOR (Melhoria)
*   Com o teste verde, melhore o código.
*   Remova duplicidade, melhore nomes, aplique padrões de design.
*   Garanta que os testes continuam verdes após cada pequena alteração.

## 🛑 Regras de Engajamento
*   **Proibido Código Sem Teste:** Se você escrever lógica de produção antes do teste, apague-a e comece de novo.
*   **Foco Atômico:** Resolva um teste por vez.
*   **Commit Progressivo:** Faça commit após cada ciclo Green ou Refactor concluído com sucesso.

---
*Código validado. Próximo passo: Próxima tarefa do plano.*
