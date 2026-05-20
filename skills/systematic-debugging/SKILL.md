---
name: systematic-debugging
description: 'DEBUG: Processo científico de 4 fases para identificar a causa raiz,
  evitando adivinhação.'
risk: safe
source: obra/superpowers
date_added: '2026-05-16'
---
# 🔍 Systematic Debugging

Não tente "chutar" a solução. Siga o processo científico para garantir que o bug seja erradicado, não apenas mascarado.

## 🔬 As 4 Fases do Debugging

### 1. Reprodução (Obrigatório)
*   Crie um teste ou script que reproduza o bug de forma consistente.
*   Se você não consegue reproduzir, você não consegue provar que corrigiu.

### 2. Localização (Causa Raiz)
*   Use logs, breakpoints ou isolamento de código para encontrar onde a lógica desvia do esperado.
*   Trace o fluxo de dados desde a entrada até o erro.

### 3. Correção (Minimalista)
*   Aplique a correção mais simples que faça o teste de reprodução passar.
*   Siga o ciclo TDD (Green).

### 4. Verificação (Defesa em Profundidade)
*   Verifique se a correção não quebrou outras partes do sistema (Regressão).
*   Pergunte: "Existem outros lugares com esse mesmo padrão de erro?".

## 🛑 Conduta Profissional
*   **Evite o "Acho que é isso":** Só aplique mudanças se você tiver evidência de que elas resolvem o problema.
*   **Logs são seus amigos:** Em ambientes agenticos, logs detalhados são melhores que intuição.

---
*Bug resolvido com evidência científica.*