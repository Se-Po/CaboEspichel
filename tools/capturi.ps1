<#
.SYNOPSIS
  Reface cele patru capturi ale paginii pentru o versiune: desktop si telefon,
  fiecare in tema luminoasa si intunecata.

.EXAMPLE
  powershell -File tools\capturi.ps1 -Versiune 0.0.5

  Scrie in docs\0.0.5\ fisierele desktop-luminos.png, desktop-intunecat.png,
  mobil-luminos.png si mobil-intunecat.png.

.NOTES
  Inaltimea paginii NU se da manual: se captureaza pe o fereastra mult mai inalta
  decat pagina, apoi se taie randurile de la baza care sunt integral fundal. Asa
  capturile raman corecte si dupa ce pagina creste sau se scurteaza.

  Tema se forteaza cu --blink-settings=preferredColorScheme (1 = luminoasa,
  0 = intunecata). Fara asta, Chromium preia tema sistemului si capturile ies
  toate pe aceeasi tema.
#>
param(
  [Parameter(Mandatory=$true)][string]$Versiune,
  [string]$Pagina,
  [string]$Edge = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.Drawing

$radacina = Split-Path $PSScriptRoot -Parent
if (-not $Pagina) { $Pagina = Join-Path $radacina "index.html" }
if (-not (Test-Path $Pagina)) { throw "Nu gasesc pagina: $Pagina" }
if (-not (Test-Path $Edge))   { throw "Nu gasesc Edge: $Edge" }

$iesire = Join-Path $radacina "docs\$Versiune"
New-Item -ItemType Directory -Force $iesire | Out-Null
$temp = Join-Path $env:TEMP "capturi-espichel"
New-Item -ItemType Directory -Force $temp | Out-Null

$teme = @(
  @{ nume="luminos";   schema=1; fundal="#f7f3ea" }
  @{ nume="intunecat"; schema=0; fundal="#17150f" }
)
$dispozitive = @(
  @{ nume="desktop"; latime=1280; plafon=9000;  coloane=1 }
  @{ nume="mobil";   latime=375;  plafon=16000; coloane=3 }
)

function Taie-FundalulDeJos([string]$cale, [System.Drawing.Color]$fundal) {
  $img = [System.Drawing.Image]::FromFile($cale)
  $bmp = New-Object System.Drawing.Bitmap($img)
  $img.Dispose()
  # LockBits, nu GetPixel: pe o imagine de 1280x9000, GetPixel ar insemna
  # milioane de apeluri si minute de asteptare. Asa citim tot blocul deodata.
  $drept = New-Object System.Drawing.Rectangle(0, 0, $bmp.Width, $bmp.Height)
  $date  = $bmp.LockBits($drept, [System.Drawing.Imaging.ImageLockMode]::ReadOnly, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $pas    = $date.Stride
  $octeti = New-Object byte[] ($pas * $bmp.Height)
  [System.Runtime.InteropServices.Marshal]::Copy($date.Scan0, $octeti, 0, $octeti.Length)
  $bmp.UnlockBits($date)

  $fB = $fundal.B; $fG = $fundal.G; $fR = $fundal.R
  $ultim = -1
  for ($y = $bmp.Height - 1; $y -ge 0; $y--) {
    $baza = $y * $pas
    $gol = $true
    for ($x = 0; $x -lt $bmp.Width; $x++) {
      $i = $baza + $x * 3
      if ([Math]::Abs($octeti[$i] - $fB) -gt 2 -or [Math]::Abs($octeti[$i+1] - $fG) -gt 2 -or [Math]::Abs($octeti[$i+2] - $fR) -gt 2) { $gol = $false; break }
    }
    if (-not $gol) { $ultim = $y; break }
  }
  if ($ultim -lt 0) { throw "Captura pare goala: $cale" }
  if ($ultim -ge $bmp.Height - 2) { Write-Warning "Pagina atinge plafonul ferestrei — mareste 'plafon'." }
  $taiat = $bmp.Clone((New-Object System.Drawing.Rectangle(0,0,$bmp.Width,($ultim+1))), $bmp.PixelFormat)
  $bmp.Dispose()
  return $taiat
}

function Aseaza-InColoane([System.Drawing.Bitmap]$sursa, [int]$coloane, [System.Drawing.Color]$fundal) {
  if ($coloane -le 1) { return $sursa }
  $gap = 24
  $latC = $sursa.Width
  $inaltC = [Math]::Ceiling($sursa.Height / $coloane)
  $out = New-Object System.Drawing.Bitmap(($latC*$coloane + $gap*($coloane-1)), $inaltC, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $g = [System.Drawing.Graphics]::FromImage($out)
  $g.Clear($fundal)
  for ($i = 0; $i -lt $coloane; $i++) {
    $sy = $i * $inaltC
    $h  = [Math]::Min($inaltC, $sursa.Height - $sy)
    if ($h -le 0) { continue }
    $g.DrawImage($sursa,
      (New-Object System.Drawing.Rectangle(($i*($latC+$gap)), 0, $latC, $h)),
      (New-Object System.Drawing.Rectangle(0, $sy, $latC, $h)),
      [System.Drawing.GraphicsUnit]::Pixel)
  }
  $g.Dispose(); $sursa.Dispose()
  return $out
}

$url = "file:///" + ((Resolve-Path $Pagina).Path.Replace([char]92, [char]47))
foreach ($d in $dispozitive) {
  foreach ($t in $teme) {
    $brut  = Join-Path $temp ("{0}-{1}.png" -f $d.nume, $t.nume)
    $final = Join-Path $iesire ("{0}-{1}.png" -f $d.nume, $t.nume)
    Remove-Item $brut -ErrorAction SilentlyContinue

    # Edge scrie zgomot pe stderr chiar si cand reuseste; in PowerShell 5.1 asta
    # ar deveni eroare terminanta din cauza lui $ErrorActionPreference = "Stop".
    $vechi = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    & $Edge --headless=new --disable-gpu --no-sandbox --hide-scrollbars `
            --force-device-scale-factor=1 --virtual-time-budget=8000 `
            "--blink-settings=preferredColorScheme=$($t.schema)" `
            "--window-size=$($d.latime),$($d.plafon)" `
            "--screenshot=$brut" $url 2>&1 | Out-Null
    $ErrorActionPreference = $vechi

    # Edge scrie asincron: asteptam ca fisierul sa se stabilizeze
    $gata = $false
    for ($i = 0; $i -lt 60; $i++) {
      if (Test-Path $brut) {
        $a = (Get-Item $brut).Length; Start-Sleep -Milliseconds 400
        $b = (Get-Item $brut).Length
        if ($a -eq $b -and $a -gt 10000) { $gata = $true; break }
      } else { Start-Sleep -Milliseconds 400 }
    }
    if (-not $gata) { throw "Captura nu s-a generat: $brut" }

    $fundal = [System.Drawing.ColorTranslator]::FromHtml($t.fundal)
    $img = Taie-FundalulDeJos $brut $fundal
    $img = Aseaza-InColoane $img $d.coloane $fundal
    $img.Save($final, [System.Drawing.Imaging.ImageFormat]::Png)
    "{0,-22} {1}x{2}" -f (Split-Path $final -Leaf), $img.Width, $img.Height
    $img.Dispose()
  }
}
"Gata: docs\$Versiune"
