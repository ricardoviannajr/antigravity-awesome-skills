---
name: verification-before-completion
description: 'FINALIZAÇÃO: Gatekeeper final. Verifica integridade, linting, testes
  e documentação antes do handoff ao humano.'
risk: safe
source: obra/superpowers
date_added: '2026-05-16'
---
# 🏁 Verification Before Completion

Antes de dizer "Terminei", você deve passar por este portão de qualidade. Apressar a entrega é a causa número 1 de bugs em produção.

## 🛡️ Checklist de Verificação Final

1. **Testes de Regressão:** Todos os testes do projeto (não apenas os novos) estão passando?
2. **Qualidade de Código:**
    - Linting sem erros.
    - Sem comentários "TODO" ou logs de debug esquecidos.
    - Variáveis e funções seguem os padrões do `AGENTS.md`.
3. **Integridade da Memória:**
    - `MEMORIA.md` foi atualizado com o progresso?
    - As decisões técnicas importantes foram registradas?
4. **Funcionalidade:** O que foi entregue atende a 100% dos critérios de sucesso definidos no Brainstorm?
5. **Documentação:** O `README.md` ou `walkthrough.md` precisam de atualização?

## 🛑 Regra do "Não Pergunte se Estiver Quebrado"
Se você sabe que algo não está perfeito, não entregue. Corrija primeiro. O tempo do usuário é precioso; não o desperdice com erros triviais que um check automático pegaria.

---
*Verificação concluída. Pronto para o handoff.*