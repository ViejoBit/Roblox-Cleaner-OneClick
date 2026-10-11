# Limpieza segura Roblox + entradas de gráficos (Roblox + Java)
# No fuerza re-descarga del cliente actual

Write-Host "=== Limpieza Roblox + Gráficos ===" -ForegroundColor Cyan
Write-Host "Cerrando procesos de Roblox..." -ForegroundColor Yellow
Get-Process -Name "*Roblox*" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 1

# 1. Limpiar subcarpetas seguras
$safePaths = @(
    "$env:LOCALAPPDATA\Roblox\logs",
    "$env:LOCALAPPDATA\Roblox\Downloads",
    "$env:LOCALAPPDATA\Roblox\LocalStorage"
)

foreach ($p in $safePaths) {
    if (Test-Path $p) {
        Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "Limpiado: $p" -ForegroundColor Green
    }
}

# Temporales
Get-ChildItem "$env:TEMP\Roblox*" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem "$env:LOCALAPPDATA\Temp\Roblox*" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

# 2. Limpiar carpetas viejas de Versions (solo las que NO tienen el cliente actual)
$versionsPath = "$env:LOCALAPPDATA\Roblox\Versions"
if (Test-Path $versionsPath) {
    Write-Host "`nRevisando carpetas de Versions..." -ForegroundColor Cyan
    $folders = Get-ChildItem $versionsPath -Directory -ErrorAction SilentlyContinue
    
    foreach ($folder in $folders) {
        $hasPlayer = Test-Path (Join-Path $folder.FullName "RobloxPlayerBeta.exe")
        $hasStudio = Test-Path (Join-Path $folder.FullName "RobloxStudioBeta.exe")
        
        if (-not $hasPlayer -and -not $hasStudio) {
            # Es una carpeta vieja/muerta (solo tiene el installer o está vacía)
            Remove-Item $folder.FullName -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "Eliminada carpeta vieja: $($folder.Name)" -ForegroundColor Yellow
        } else {
            Write-Host "Conservada (cliente actual): $($folder.Name)" -ForegroundColor Green
        }
    }
}

# 3. Limpiar entradas muertas de Gráficos (UserGpuPreferences)
$regPath = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
if (Test-Path $regPath) {
    Write-Host "`nLimpiando entradas de Gráficos..." -ForegroundColor Cyan
    
    $props = Get-ItemProperty $regPath -ErrorAction SilentlyContinue
    $toRemove = @()
    
    foreach ($prop in $props.PSObject.Properties) {
        $name = $prop.Name
        # Ignorar propiedades del sistema
        if ($name -match "^(PS|DirectX)") { continue }
        
        # Solo nos interesan Roblox y java.exe
        if ($name -match "Roblox|java\.exe") {
            if (-not (Test-Path $name)) {
                $toRemove += $name
                Write-Host "Marcada para eliminar (ruta no existe): $name" -ForegroundColor Yellow
            } else {
                Write-Host "Conservada (ruta válida): $name" -ForegroundColor Green
            }
        }
    }
    
    foreach ($dead in $toRemove) {
        Remove-ItemProperty -Path $regPath -Name $dead -ErrorAction SilentlyContinue
        Write-Host "Eliminada: $dead" -ForegroundColor Red
    }
    
    if ($toRemove.Count -eq 0) {
        Write-Host "No había entradas muertas de Roblox/Java." -ForegroundColor Green
    }
}

Write-Host "`n=== Limpieza terminada ===" -ForegroundColor Green
Write-Host "Puedes abrir Roblox de nuevo. No debería forzar descarga completa." -ForegroundColor Cyan
Pause
