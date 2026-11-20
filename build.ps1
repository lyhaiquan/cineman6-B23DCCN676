# Bien dich toan bo src/**/*.java ra WebContent/WEB-INF/classes.
# Chay: powershell -ExecutionPolicy Bypass -File build.ps1
$ErrorActionPreference = 'Stop'

$javac = 'C:\Program Files\Microsoft\jdk-17.0.19.10-hotspot\bin\javac.exe'
$root  = $PSScriptRoot
$src   = Join-Path $root 'src'
$lib   = Join-Path $root 'WebContent\WEB-INF\lib'
$out   = Join-Path $root 'WebContent\WEB-INF\classes'

if (-not (Test-Path $javac)) {
    Write-Error "Khong tim thay javac: $javac"
    exit 1
}
New-Item -ItemType Directory -Force -Path $out | Out-Null

$files = Get-ChildItem -Path $src -Recurse -Filter *.java | ForEach-Object { '"' + ($_.FullName -replace '\\', '/') + '"' }
if (-not $files) {
    Write-Error 'Khong co file .java nao trong src'
    exit 1
}
$argfile = Join-Path $env:TEMP ('cineman6_sources_' + [guid]::NewGuid().ToString('N') + '.txt')
[System.IO.File]::WriteAllLines($argfile, [string[]]$files)

$cp = (Join-Path $lib '*')
& $javac -encoding UTF-8 -cp $cp -d $out "@$argfile"
$code = $LASTEXITCODE
Remove-Item $argfile -ErrorAction SilentlyContinue

if ($code -eq 0) {
    Write-Host ("Bien dich xong " + $files.Count + " file -> " + $out)
} else {
    Write-Host "Bien dich LOI (ma $code)"
}
exit $code
