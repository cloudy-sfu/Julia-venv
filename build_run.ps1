param(
    [string]$script,
    [string]$base_dir
)

# 1. Determine base directory: use provided path or default to current directory.
if (-not $base_dir) {
    $base_dir = (Get-Location).Path   # default: current working directory
} else {
    # Expand relative base path to absolute
    $base_dir = (Resolve-Path -Path $base_dir).Path
}

# 2. Find the latest Julia installation under %LOCALAPPDATA%\Programs\Julia-*
$julia_path = Get-ChildItem -Directory -Path "$env:LOCALAPPDATA\Programs" -Filter "Julia-*" |
    Sort-Object { [version]($_.Name -replace '^Julia-','') } -Descending |
    Select-Object -First 1 |
    ForEach-Object { Join-Path $_.FullName "bin\julia.exe" }

# If Julia not found, prompt the user for the path to julia.exe
if (-not $julia_path -or -not (Test-Path $julia_path)) {
    $julia_path = Read-Host "Julia installed path (path to `"...\bin\julia.exe`"):"
}

# If the given Julia path still doesn’t exist, abort with an error.
if (-not (Test-Path $julia_path)) {
    Write-Error "Julia not found at $julia_path"
    exit 1
} else {
    Echo "Found Julia at $julia_path"
}

# 3. Convert base directory path to Unix-style for Julia (replace '\' with '/')
$base_dir_unix = ($base_dir -replace '\\', '/').TrimEnd('/')

# 4. Set environment variables for Julia to use this project and local depot
$env:JULIA_DEPOT_PATH = Join-Path $base_dir "local_depot"
$env:JULIA_PROJECT    = $base_dir

# 5. Activate and instantiate the project environment using Julia
$activate_script = Join-Path $base_dir "_activate.jl"

# Check for existing activation script to avoid overwriting
if (Test-Path $activate_script) {
    Write-Error "Temporary activation script already exists at $activate_script Please remove it before retrying."
    exit 1
}

@"
using Pkg
Pkg.activate("$base_dir_unix")
Pkg.instantiate()
"@ | Set-Content -Encoding UTF8 $activate_script

& "$julia_path" --project="$base_dir" "$activate_script"

Remove-Item -Force $activate_script

# 6. If a Julia script file was provided, run it; otherwise, launch the REPL.
$script_abs_path = Join-Path $base_dir $script
$script_path = if (Test-Path $script_abs_path) { $script_abs_path } else { $script }

if (-not $script -or -not (Test-Path $script_path)) {
    Echo "Enter interactive Julia REPL. Press Ctrl+D to quit."
    & "$julia_path" --project="$base_dir"
} else {
    & "$julia_path" --project="$base_dir" "$script_path"
}
