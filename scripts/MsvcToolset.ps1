<#
.SYNOPSIS
    Shared helpers for the MSVC toolset scripts.

.DESCRIPTION
    Dot-source this file to use the helpers from another script:

        . (Join-Path $PSScriptRoot 'MsvcToolset.ps1')

    The helpers are kept separate so the install, verify, and environment
    scripts share one definition of the toolset layout.
#>

Set-StrictMode -Version Latest

function Assert-WindowsHost {
    <#
    .SYNOPSIS
        Throws unless the current host is Windows.
    #>
    [CmdletBinding()]
    param()

    # Windows PowerShell only runs on Windows and does not define $IsWindows,
    # which PowerShell Core provides on every platform.
    $onWindows = $PSVersionTable.PSEdition -eq 'Desktop' -or $IsWindows

    if (-not $onWindows) {
        throw 'The MSVC toolset scripts require Windows.'
    }
}

function Get-MsvcToolsComponent {
    <#
    .SYNOPSIS
        Maps a target architecture to its Visual Studio MSVC tools component.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateSet('x64', 'arm64')]
        [string] $Architecture
    )

    switch ($Architecture) {
        'x64' { 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64' }
        'arm64' { 'Microsoft.VisualStudio.Component.VC.Tools.ARM64' }
    }
}

function Get-VswherePath {
    <#
    .SYNOPSIS
        Returns the path of the Visual Studio Installer copy of vswhere.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $vswhere = Join-Path ${env:ProgramFiles(x86)} 'Microsoft Visual Studio\Installer\vswhere.exe'
    if (-not (Test-Path -LiteralPath $vswhere)) {
        throw "vswhere.exe not found at $vswhere"
    }

    return $vswhere
}

function Get-MsvcInstance {
    <#
    .SYNOPSIS
        Returns the Visual Studio instance installed at a given path.

    .PARAMETER InstallPath
        Directory that holds the installation to describe.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $InstallPath
    )

    $vswhere = Get-VswherePath
    $instance = & $vswhere -path $InstallPath -prerelease -format json |
        ConvertFrom-Json |
        Select-Object -First 1

    if (-not $instance) {
        throw "No Visual Studio instance found at $InstallPath"
    }

    return $instance
}

function ConvertFrom-EnvironmentBlock {
    <#
    .SYNOPSIS
        Converts `set` output lines into a name to value hash table.

    .PARAMETER Line
        Lines of `NAME=VALUE` text to convert.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(ValueFromPipeline)]
        [AllowEmptyCollection()]
        [string[]] $Line
    )

    begin {
        $table = @{}
    }

    process {
        foreach ($entry in $Line) {
            if ($entry -match '^([^=]+)=(.*)$') {
                $table[$Matches[1]] = $Matches[2]
            }
        }
    }

    end {
        return $table
    }
}

function Get-VcVarsEnvironment {
    <#
    .SYNOPSIS
        Returns the environment variables that vcvarsall.bat adds or changes.

    .PARAMETER InstallPath
        Directory that holds the Visual Studio installation to use.

    .PARAMETER Architecture
        Architecture argument passed to vcvarsall.bat.
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $InstallPath,

        [Parameter(Mandatory)]
        [ValidateSet('x64', 'arm64')]
        [string] $Architecture
    )

    $vcvarsall = Join-Path $InstallPath 'VC\Auxiliary\Build\vcvarsall.bat'
    if (-not (Test-Path -LiteralPath $vcvarsall)) {
        throw "vcvarsall.bat not found at $vcvarsall"
    }

    $before = cmd /c 'set' | ConvertFrom-EnvironmentBlock
    $after = cmd /c "`"$vcvarsall`" $Architecture >nul && set" | ConvertFrom-EnvironmentBlock
    if ($LASTEXITCODE -ne 0) {
        throw "vcvarsall.bat $Architecture failed with exit code $LASTEXITCODE"
    }

    $changed = @{}
    foreach ($name in $after.Keys) {
        if ($before[$name] -ne $after[$name]) {
            $changed[$name] = $after[$name]
        }
    }

    return $changed
}

function Get-MsvcNinjaDirectory {
    <#
    .SYNOPSIS
        Returns the directory of the Ninja build shipped with the C++ CMake
        tools component.

    .PARAMETER InstallPath
        Directory that holds the Visual Studio installation to use.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $InstallPath
    )

    $ninjaDirectory = Join-Path $InstallPath 'Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja'
    if (-not (Test-Path -LiteralPath (Join-Path $ninjaDirectory 'ninja.exe'))) {
        throw "ninja.exe not found in $ninjaDirectory"
    }

    return $ninjaDirectory
}
