<#
.SYNOPSIS
    Applies an MSVC developer environment to the current session.

.DESCRIPTION
    Runs vcvarsall.bat from a Visual Studio installation for the requested
    architecture, applies every variable it adds or changes to the current
    PowerShell session, and adds the Ninja build shipped with the C++ CMake
    tools component to the path. Dot-source or run this script before using the
    windows-msvc CMake presets from an ordinary PowerShell prompt.

.PARAMETER Architecture
    Architecture argument passed to vcvarsall.bat. Defaults to the
    architecture of the current machine.

.PARAMETER InstallPath
    Directory that holds the Visual Studio installation to use.

.PARAMETER GitHubEnvironment
    Also append the changes to the GITHUB_ENV and GITHUB_PATH files so later
    steps of a GitHub Actions job inherit the environment.

.EXAMPLE
    ./scripts/Enter-MsvcEnvironment.ps1

    Sets up the developer environment for the current architecture.

.EXAMPLE
    ./scripts/Enter-MsvcEnvironment.ps1 -Architecture arm64 -GitHubEnvironment

    Sets up the ARM64 developer environment and exports it to later workflow
    steps.
#>
[CmdletBinding()]
param(
    [ValidateSet('x64', 'arm64')]
    [string] $Architecture = $(
        if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
    ),

    [ValidateNotNullOrEmpty()]
    [string] $InstallPath = 'C:\VisualStudioPreview',

    [switch] $GitHubEnvironment
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

. (Join-Path $PSScriptRoot 'MsvcToolset.ps1')

Assert-WindowsHost

if ($GitHubEnvironment) {
    if (-not $env:GITHUB_ENV -or -not $env:GITHUB_PATH) {
        throw 'GITHUB_ENV and GITHUB_PATH must be set to use -GitHubEnvironment.'
    }
}

$changed = Get-VcVarsEnvironment -InstallPath $InstallPath -Architecture $Architecture
$ninjaDirectory = Get-MsvcNinjaDirectory -InstallPath $InstallPath

foreach ($name in $changed.Keys) {
    Set-Item -LiteralPath "env:$name" -Value $changed[$name]
}

$env:PATH = $ninjaDirectory + [System.IO.Path]::PathSeparator + $env:PATH

if ($GitHubEnvironment) {
    foreach ($name in $changed.Keys) {
        # Names with parentheses are not valid environment file entries.
        if ($name -match '[()]') {
            continue
        }

        "$name=$($changed[$name])" | Out-File -FilePath $env:GITHUB_ENV -Append -Encoding utf8
    }

    $ninjaDirectory | Out-File -FilePath $env:GITHUB_PATH -Append -Encoding utf8
}

Write-Information "Entered the $Architecture developer environment from $InstallPath"
