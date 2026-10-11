# Roblox Cleaner OneClick

Script de PowerShell de un solo clic para limpiar la basura residual de **Roblox** en Windows **sin desinstalarlo**.

## Qué limpia

- Carpetas de caché y logs seguras (`logs`, `Downloads`, `LocalStorage`, temporales).
- Carpetas viejas/muertas dentro de `%LOCALAPPDATA%\Roblox\Versions` (solo las que **no** contienen el cliente actual `RobloxPlayerBeta.exe` o `RobloxStudioBeta.exe`).
- Entradas muertas en la lista de **Configuración de Gráficos** de Windows (`UserGpuPreferences`) para:
  - Roblox (rutas que ya no existen).
  - `java.exe` (rutas que ya no existen).

Deja intactas las entradas actuales (las que apuntan a un archivo que sí existe) y **no fuerza** la re-descarga del cliente de Roblox.

## Cómo usarlo

1. Descarga el archivo `LimpiarRoblox.ps1`.
2. Clic derecho sobre él → **Ejecutar con PowerShell**.
3. Si Windows te pregunta por la política de ejecución, puedes permitirla temporalmente o ejecutarlo así:

```powershell
powershell -ExecutionPolicy Bypass -File .\LimpiarRoblox.ps1
```

4. Espera a que termine y abre Roblox de nuevo.

## Notas

- Cierra Roblox antes de ejecutarlo (el script también intenta matar los procesos).
- Es seguro para el cliente actual: solo borra versiones que no tienen el ejecutable principal.
- Las entradas de gráficos se recrean solas si Roblox o Java las necesitan de nuevo.

---

Hecho para limpiar el mugrero de carpetas y las entradas duplicadas/muertas en la lista de gráficos.
