<#
.SYNOPSIS
    Verifies that an install path holds a preview MSVC toolset.

.DESCRIPTION
    Queries the Visual Studio installation at the given path and fails when it
    is missing or is not a prerelease build. Use it after
    Install-MsvcPreview.ps1 to confirm that a machine really is on the preview
    toolset rather than a stale stable install.

.PARAMETER InstallPath
    Directory that holds the preview installation.

.EXAMPLE
    ./scripts/Test-MsvcPreview.ps1

    Reports the preview toolset in use, or fails when it is not a preview.
#>
[CmdletBinding()]
param(
    [ValidateNotNullOrEmpty()]
    [string] $InstallPath = 'C:\VisualStudioPreview'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

. (Join-Path $PSScriptRoot 'MsvcToolset.ps1')

Assert-WindowsHost

$instance = Get-MsvcInstance -InstallPath $InstallPath

if (-not $instance.isPrerelease) {
    throw "Expected a preview toolset, found $($instance.displayName) $($instance.installationVersion)"
}

Write-Information "Using $($instance.displayName) $($instance.installationVersion)"
