# =====================================================================
#  build.ps1 - compile a jiangyi .tex to PDF with xelatex,
#  auto-installing any missing TinyTeX packages via tlmgr.
#
#  Usage:  powershell -File build.ps1 <file>.tex
#
#  Behaviour: run "latexmk -xelatex"; if the .log reports
#  "File 'X.sty' not found", locate the owning package with
#  "tlmgr search --global --file", install it, then retry
#  (up to -MaxRetries times). ASCII-only so it parses on any locale.
#  Native stderr is NOT merged with 2>&1 (that wraps lines as errors
#  under Windows PowerShell 5.1); we scan the .log file instead.
# =====================================================================
param(
  [Parameter(Mandatory = $true, Position = 0)][string]$TexFile,
  [int]$MaxRetries = 8
)

$tex  = (Resolve-Path -LiteralPath $TexFile).Path
$dir  = Split-Path -Parent $tex
$base = [IO.Path]::GetFileNameWithoutExtension($tex)
$pdf  = Join-Path $dir "$base.pdf"
$log  = Join-Path $dir "$base.log"

Push-Location $dir
try {
  for ($i = 1; $i -le $MaxRetries; $i++) {
    # drop latexmk state so a prior failure does not block a rebuild
    Remove-Item -LiteralPath (Join-Path $dir "$base.fdb_latexmk") -ErrorAction SilentlyContinue

    & latexmk -xelatex -interaction=nonstopmode -halt-on-error "$base.tex"
    $code = $LASTEXITCODE
    if ($code -eq 0 -and (Test-Path -LiteralPath $pdf)) {
      Write-Host "BUILD OK -> $pdf"
      return
    }

    $logTxt = if (Test-Path -LiteralPath $log) { Get-Content -LiteralPath $log -Raw } else { "" }

    # find the missing .sty / .cls ('' is one literal single quote)
    $m = [regex]::Match($logTxt, '([A-Za-z0-9._-]+)\.(sty|cls)'' not found')
    if (-not $m.Success) {
      Write-Host "BUILD FAILED (not a missing-package error). See $log"
      throw "compile failed; see $log"
    }

    $stem = $m.Groups[1].Value
    $ext  = $m.Groups[2].Value
    Write-Host ">> missing $stem.$ext - searching owning package ..."

    $pkgs = & tlmgr search --global --file "/$stem.$ext" |
            Select-String '^([A-Za-z0-9._-]+):\s*$' |
            ForEach-Object { $_.Matches[0].Groups[1].Value } |
            Select-Object -Unique
    if (-not $pkgs) {
      throw "could not locate the package owning $stem.$ext; install it manually."
    }

    Write-Host (">> tlmgr install " + ($pkgs -join ' '))
    & tlmgr install @pkgs | Out-Null
  }
  throw "BUILD FAILED: exceeded MaxRetries ($MaxRetries)."
}
finally {
  Pop-Location
}
