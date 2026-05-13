# install-workflows.ps1
# Script para garantir que os workflows globais estejam instalados na máquina atual.

$globalDir = "$env:USERPROFILE\.gemini\antigravity\global_workflows"
$sourceDir = "$PSScriptRoot\..\workflows"

if (-not (Test-Path $globalDir)) {
    Write-Host "Criando diretório de workflows globais: $globalDir" -ForegroundColor Cyan
    New-Item -Path $globalDir -ItemType Directory -Force | Out-Null
}

Write-Host "Instalando/Atualizando workflows globais..." -ForegroundColor Green
Get-ChildItem "$sourceDir\*.md" | ForEach-Object {
    Copy-Item $_.FullName -Destination $globalDir -Force
    Write-Host " - $($_.Name) instalado."
}

Write-Host "Workflows prontos para uso." -ForegroundColor Green
