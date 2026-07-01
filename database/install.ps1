param(
  [string]$HostName = "127.0.0.1",
  [int]$Port = 3306,
  [string]$User = "root",
  [string]$Password = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

function Invoke-MySqlFile {
  param(
    [string]$FilePath
  )

  $args = @(
    "-h", $HostName,
    "-P", $Port,
    "-u", $User,
    "--default-character-set=utf8mb4"
  )

  if ($Password) {
    $args += @("-p$Password")
  }

  Get-Content -Path $FilePath -Raw -Encoding UTF8 | mysql @args
  if ($LASTEXITCODE -ne 0) {
    throw "Error al ejecutar $FilePath"
  }
}

if (-not (Get-Command mysql -ErrorAction SilentlyContinue)) {
  throw "mysql no está en el PATH. Instala MySQL Client o usa Docker: docker compose up -d"
}

Write-Host "Aplicando schema.sql..."
Invoke-MySqlFile -FilePath (Join-Path $scriptDir "schema.sql")

Write-Host "Aplicando seed.sql..."
Invoke-MySqlFile -FilePath (Join-Path $scriptDir "seed.sql")

Write-Host "Aplicando seed-demo.sql..."
Invoke-MySqlFile -FilePath (Join-Path $scriptDir "seed-demo.sql")

Write-Host "Base de datos uidepet_huellitas lista."
