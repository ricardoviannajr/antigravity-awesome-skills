<#
.SYNOPSIS
    Este script automatiza a propagação das novas regras de governança e do template de memória 
    para todos os projetos dentro da pasta de documentos do usuário.
    Ele garante que todos os repositórios do ecossistema Antigravity sigam o mesmo padrão de qualidade.
#>

# Define o caminho raiz onde todos os projetos estão localizados
# O script usa a variável de ambiente USERPROFILE para encontrar a pasta Documentos do usuário atual.
$rootPath = Join-Path $env:USERPROFILE "Documents\# Projetos Antigravity"

# Define o caminho onde este repositório de configuração está localizado
# Este é o "Mestre" de onde os arquivos serão copiados.
$configPath = "c:\Users\User\Documents\# projetos antigravity\Antigravity-Config"

# Obtém a lista de todas as pastas (diretórios) dentro do caminho raiz dos projetos
# Cada pasta é tratada como um projeto individual.
$directories = Get-ChildItem -Path $rootPath -Directory

# Exibe uma mensagem inicial colorida no terminal para informar o início do processo
Write-Host "--- Iniciando Atualização de Governança e Memória ---" -ForegroundColor Cyan

# Inicia um loop para percorrer cada diretório (projeto) encontrado
foreach ($dir in $directories) {
    # Armazena o caminho completo do projeto atual
    $targetPath = $dir.FullName
    
    # Verifica se o diretório atual é o próprio "Antigravity-Config"
    # Se for, o script pula para a próxima iteração, pois não faz sentido copiar arquivos para si mesmo.
    if ($dir.Name -eq "Antigravity-Config") { continue }
    
    # Exibe o nome do projeto que está sendo processado no momento
    Write-Host "Processando: $($dir.Name)" -ForegroundColor Yellow
    
    # 1. GARANTIR PASTA ANTIGRAVITY/ NO DESTINO
    # Todos os projetos devem ter uma pasta chamada 'antigravity' para armazenar regras de governança.
    $antigravityFolder = Join-Path $targetPath "antigravity"
    
    # Se a pasta não existir no projeto de destino, ela é criada.
    if (-not (Test-Path $antigravityFolder)) {
        # O parâmetro -Force garante que o comando não falhe se algo inesperado ocorrer.
        New-Item -ItemType Directory -Path $antigravityFolder -Force | Out-Null
    }
    
    # 2. COPIAR ARQUIVOS DE GOVERNANÇA (A FONTE DA VERDADE)
    # Copia os arquivos AGENTS.md e GEMINI.md do repositório mestre para o projeto de destino.
    # O parâmetro -Force sobrescreve os arquivos existentes se eles já estiverem lá.
    Copy-Item "$configPath\antigravity\AGENTS.md" -Destination "$antigravityFolder\AGENTS.md" -Force
    Copy-Item "$configPath\antigravity\GEMINI.md" -Destination "$antigravityFolder\GEMINI.md" -Force
    
    # Também copia o template de memória para a raiz do projeto.
    Copy-Item "$configPath\MEMORIA_TEMPLATE.md" -Destination "$targetPath\MEMORIA_TEMPLATE.md" -Force
    
    # 3. ATUALIZAR MEMORIA.MD
    # A MEMORIA.md é o "cérebro" do projeto. O script tenta atualizar arquivos antigos para o novo padrão.
    $memoriaFile = Join-Path $targetPath "MEMORIA.md"
    
    # Verifica se o arquivo MEMORIA.md já existe no projeto.
    if (Test-Path $memoriaFile) {
        # Lê o conteúdo atual do arquivo.
        $content = Get-Content $memoriaFile -Raw
        
        # Se o conteúdo for muito curto (menos de 500 caracteres), considera-se que ele precisa de uma estrutura melhor.
        # Exceção feita ao 'Dashboard SIADS' que pode ter regras específicas.
        if ($content.Length -lt 500 -and $dir.Name -ne "Dashboard SIADS") {
            # Lê o conteúdo do template padrão.
            $template = Get-Content "$configPath\MEMORIA_TEMPLATE.md" -Raw
            
            # Monta um novo conteúdo: Aviso + Template Novo + Conteúdo Antigo (preservando o histórico).
            $newContent = "# ⚠️ AVISO: Esta memória está sendo migrada para o novo padrão cerebral.`n`n" + $template + "`n---`n`n" + $content
            
            # Salva o arquivo atualizado.
            Set-Content $memoriaFile $newContent -Force
        }
    } else {
        # Se o projeto não tiver um arquivo MEMORIA.md, cria um novo usando o template.
        Copy-Item "$configPath\MEMORIA_TEMPLATE.md" -Destination $memoriaFile -Force
    }
    
    # 4. SINCRONIZAÇÃO COM O GIT (CONTROLE DE VERSÃO)
    # Se o projeto estiver sob controle de versão Git, faz o commit e push das mudanças automaticamente.
    if (Test-Path "$targetPath\.git") {
        try {
            # Adiciona todos os arquivos alterados ao stage do Git.
            git -C $targetPath add .
            
            # Cria um commit com uma mensagem padrão explicando que as regras de governança foram atualizadas.
            git -C $targetPath commit -m "[Log: Propagação de nova governança e padrão de MEMORIA.md cerebral - Nível Jr de Comentários]"
            
            # Envia as alterações para o repositório remoto (ex: GitHub).
            git -C $targetPath push
            
            # Informa que a sincronização foi bem-sucedida.
            Write-Host "✅ Sincronizado com sucesso." -ForegroundColor Green
        } catch {
            # Caso ocorra algum erro no processo de Git, exibe a mensagem de erro em vermelho.
            Write-Host "❌ Erro ao sincronizar Git: $_" -ForegroundColor Red
        }
    }
}

# Exibe mensagem final informando que todos os projetos foram processados.
Write-Host "--- Propagação Concluída ---" -ForegroundColor Green
