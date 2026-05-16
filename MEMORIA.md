# MEMORIA - antigravity-awesome-skills

STATUS: CONCLUÍDO (UPGRADED TO SUPERPOWERS)

## Checkpoints de Consciência

### 2026-05-16
- **Automação Code Review Skills:** Implementação de script Node.js (`scripts/sync-code-review-skills.js`) para scraping dinâmico do Claude Code Marketplace (top 25 skills de Code Review).
- **Lógica de Sparse Cloning:** Script agora localiza cirurgicamente arquivos `SKILL.md` em repositórios externos, mesmo com estruturas de pastas variadas, e normaliza o metadado `name` para conformidade com o ecossistema.
- **Workflow Global:** Criação do comando `/update-skills-code-review` no sistema global para acionamento recorrente da sincronização.
- **Upgrade Metodológico Superpowers:** Migração do ecossistema para a metodologia "Superpowers Agentic".
- **Skill Maestro:** Criação da meta-skill `using-superpowers` para orquestração de governança e skill-checks.
- **Refatoração Brainstorming:** Atualização da skill de brainstorming para modo socrático e bloqueio de execução prematura.
- **Novas Skills de Disciplina:** Adição de `writing-plans` (atomic tasks), `test-driven-development` (TDD), `systematic-debugging` (ciência de debug) e `verification-before-completion` (final quality gate).
- **Consolidação do Catálogo:** Sincronização de `skills_index.json`, `SKILLS.md` e `CATALOG.md` com as novas diretrizes.

### 2026-05-12
- Bootstrap de governança realizado (Regra 10).
- Integração de `find-skills`, `agent-browser` e `supabase-postgres-best-practices` finalizada.
- Inclusão do pacote Inference.sh (`ai-image`, `ai-video`, `ai-avatar`, `agent-tools`, `infsh-cli`).
- Importação massiva de skills de Marketing (CRO/SEO), Design, RunComfy e Firecrawl.
- Integração do ecossistema Caveman (juliusbrussee) para eficiência de tokens.
- Repositório sincronizado com **1484 skills** indexadas.

## Decisões Técnicas
- [X] Adoção da Doutrina Superpowers como "Sistema Operacional" do ecossistema Antigravity.
- [X] Uso de scripts Python para atualização atômica de arquivos de índice em grande escala (evitando corrupção).
- [X] Manutenção do branch `main` como branch principal de produção.

## Pendências
- [ ] Propagar as novas skills `using-superpowers` e `brainstorming` refatorada para os projetos ativos via `scripts/sync-all-projects.ps1`.

