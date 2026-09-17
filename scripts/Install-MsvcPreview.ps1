<#
.SYNOPSIS
    Installs or updates the latest Visual Studio preview MSVC toolset.

.DESCRIPTION
    Downloads the Visual Studio Build Tools bootstrapper for a preview channel
    and runs it against the requested install path. The bootstrapper installs
    the toolset when the path is empty and updates it when a matching
    installation already exists, so the same command keeps a developer machine
    or a continuous integration runner on the latest preview build.

.PARAMETER Architecture
    Target architecture whose MSVC tools component is installed. Defaults to
    the architecture of the current machine.

.PARAMETER InstallPath
    Directory that holds the preview installation.

.PARAMETER BootstrapperUrl
    URL of the Build Tools bootstrapper for the preview channel.

.PARAMETER ChannelUri
    Channel URI passed to the bootstrapper so it installs preview builds.

.EXAMPLE
    ./scripts/Install-MsvcPreview.ps1

    Installs or updates the preview toolset for the current architecture.

.EXAMPLE
    ./scripts/Install-MsvcPreview.ps1 -Architecture arm64

    Adds the ARM64 MSVC tools to the preview installation.
#>
[CmdletBinding()]
param(
    [ValidateSet('x64', 'arm64')]
    [string] $Architecture = $(
        if ($env:PROCESSOR_ARCHITECTURE -eq 'ARM64') { 'arm64' } else { 'x64' }
    ),

    [ValidateNotNullOrEmpty()]
    [string] $InstallPath = 'C:\VisualStudioPreview',

    [ValidateNotNullOrEmpty()]
    [string] $BootstrapperUrl = 'https://aka.ms/vs/insiders/vs_BuildTools.exe',

    [ValidateNotNullOrEmpty()]
    [string] $ChannelUri = 'https://aka.ms/vs/insiders/channel'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

. (Join-Path $PSScriptRoot 'MsvcToolset.ps1')

Assert-WindowsHost

$vcToolsComponent = Get-MsvcToolsComponent -Architecture $Architecture

$downloadDirectory = if ($env:RUNNER_TEMP) {
    $env:RUNNER_TEMP
}
else {
    [System.IO.Path]::GetTempPath()
}
$bootstrapper = Join-Path $downloadDirectory 'vs_BuildTools.exe'

Write-Information "Downloading $BootstrapperUrl"
$previousProgressPreference = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'
try {
    Invoke-WebRequest -Uri $BootstrapperUrl -OutFile $bootstrapper
}
finally {
    $ProgressPreference = $previousProgressPreference
}

$arguments = @(
    '--quiet', '--wait', '--norestart', '--nocache',
    '--channelUri', $ChannelUri,
    '--installPath', $InstallPath,
    '--add', 'Microsoft.VisualStudio.Workload.VCTools',
    '--add', 'Microsoft.VisualStudio.Component.VC.CMake.Project',
    '--add', $vcToolsComponent,
    '--includeRecommended'
)

Write-Information "Installing $vcToolsComponent into $InstallPath"
try {
    $install = Start-Process -FilePath $bootstrapper -ArgumentList $arguments -Wait -PassThru
}
finally {
    Remove-Item -LiteralPath $bootstrapper -Force -ErrorAction SilentlyContinue
}

# 3010 means the install succeeded but wants a reboot that is not needed to
# build from the command line.
if ($install.ExitCode -ne 0 -and $install.ExitCode -ne 3010) {
    throw "Visual Studio preview install failed with exit code $($install.ExitCode)"
}
