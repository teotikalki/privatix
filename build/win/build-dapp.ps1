<#
.SYNOPSIS
    Build single component of Privatix application.
.DESCRIPTION
    Build single component of Privatix application. Components:
    - core (aka controller). dappcrtl repo
    - openvpn service plug-in. dapp-openvpn repo
    - installer. dapp-installer repo
    - GUI. dapp-gui repo
    - prepare core DB

.PARAMETER branch
    Checkout existing git branch

.PARAMETER gitpull
    Pull from git

.PARAMETER godep
    Use go dependency

.EXAMPLE
    build-dapp.ps1 [-dappctrl] [-branch <string>] [-gitpull] [-godep] [<CommonParameters>]
    build-dapp.ps1 [-dappopenvpn] [-branch <string>] [-gitpull] [-godep] [<CommonParameters>]
    build-dapp.ps1 [-dappinstaller] [-branch <string>] [-gitpull] [-godep] [<CommonParameters>]
    build-dapp.ps1 [-dappgui] [-branch <string>] [-gitpull] [-wd <string>] [-package] [-shortcut] [<CommonParameters>]
    build-dapp.ps1 [-dappdb] [-dappctrlconf <string>] [-settingSQL <string>] [-schemaSQL <string>] [-dataSQL <string>] [-psqlpath <string>] [<CommonParameters>]

#>
[cmdletbinding(DefaultParameterSetName = 'dappctrl')]
# Build dappctrl
param(
    #component selector parameters
    [Parameter(ParameterSetName = "dappctrl", HelpMessage = "build dappctrl")]
    [switch]$dappctrl,
    [Parameter(ParameterSetName = "dappgui", HelpMessage = "build dappgui")]
    [switch]$dappgui,
    [Parameter(ParameterSetName = "dappdb", HelpMessage = "init database")]
    [switch]$dappdb,
    [Parameter(ParameterSetName = "dappopenvpn", HelpMessage = "build dapp-openvpn")]
    [switch]$dappopenvpn,
    [Parameter(ParameterSetName = "dappinstaller", HelpMessage = "build dapp-installer")]
    [switch]$dappinstaller,
    # common parameters (not always between all components)
    [Parameter(ParameterSetName = "dappctrl", HelpMessage = "git branch")]
    [Parameter(ParameterSetName = "dappgui", HelpMessage = "git branch")]
    [Parameter(ParameterSetName = "dappopenvpn", HelpMessage = "git branch")]
    [Parameter(ParameterSetName = "dappinstaller", HelpMessage = "git branch")]
    [string]$branch,        
    [Parameter(ParameterSetName = "dappctrl", HelpMessage = "git pull")]
    [Parameter(ParameterSetName = "dappgui", HelpMessage = "git pull")]
    [Parameter(ParameterSetName = "dappopenvpn", HelpMessage = "git pull")]
    [Parameter(ParameterSetName = "dappinstaller", HelpMessage = "git pull")]
    [switch]$gitpull,
    [Parameter(ParameterSetName = "dappctrl", HelpMessage = "run go dependency check")]
    [Parameter(ParameterSetName = "dappopenvpn", HelpMessage = "run go dependency check")]
    [Parameter(ParameterSetName = "dappinstaller", HelpMessage = "run go dependency check")]
    [switch]$godep,
    # dappgui parameters
    [Parameter(ParameterSetName = "dappgui", HelpMessage = "Path to where to clone dapp-gui")]
    [string]$wd,
    [Parameter(ParameterSetName = "dappgui", HelpMessage = "whether to package gui")]
    [switch]$package,
    [Parameter(ParameterSetName = "dappgui", HelpMessage = "Create shortcut")]
    [switch]$shortcut,
    # database parameters
    [Parameter(ParameterSetName = "dappdb", HelpMessage = "dappctrl config file path")]
    [string]$dappctrlconf,
    [Parameter(ParameterSetName = "dappdb", HelpMessage = "settings.sql path")]
    [string]$settingSQL,
    [Parameter(ParameterSetName = "dappdb", HelpMessage = "schema.sql path")]
    [string]$schemaSQL,
    [Parameter(ParameterSetName = "dappdb", HelpMessage = "prod_data.sql path")]
    [string]$dataSQL,
    [Parameter(ParameterSetName = "dappdb", HelpMessage = "psql.exe path")]
    [string]$psqlpath

)

$ErrorActionPreference = "Stop"
Write-Host "Working on $($psCmdlet.ParameterSetName)" -ForegroundColor Green
switch ($psCmdlet.ParameterSetName) {
    "dappctrl" {
        import-module (join-path $PSScriptRoot "build-dappctrl.psm1" -resolve) -DisableNameChecking -ErrorAction Stop    
        $PSBoundParameters.Remove($psCmdlet.ParameterSetName) | Out-Null
        build-dappctrl @PSBoundParameters
        Remove-Module "build-dappctrl"
        break
    }
    "dappgui" {
        import-module (join-path $PSScriptRoot "build-dappgui.psm1" -resolve) -DisableNameChecking -ErrorAction Stop
        $PSBoundParameters.Remove($psCmdlet.ParameterSetName) | Out-Null
        build-dappgui @PSBoundParameters
        Remove-Module "build-dappgui"
        break
    }
    "dappdb" {
        import-module (join-path $PSScriptRoot "deploy-dappdb.psm1" -resolve) -DisableNameChecking -ErrorAction Stop
        $PSBoundParameters.Remove($psCmdlet.ParameterSetName) | Out-Null
        deploy-dappdb @PSBoundParameters
        Remove-Module "deploy-dappdb"
        break
    }
    "dappopenvpn" {
        import-module (join-path $PSScriptRoot "build-dappopenvpn.psm1" -resolve) -DisableNameChecking -ErrorAction Stop
        $PSBoundParameters.Remove($psCmdlet.ParameterSetName) | Out-Null
        build-dappopenvpn @PSBoundParameters
        Remove-Module "build-dappopenvpn"
        break
    }
    "dappinstaller" {
        import-module (join-path $PSScriptRoot "build-dappinstaller.psm1" -resolve) -DisableNameChecking -ErrorAction Stop
        $PSBoundParameters.Remove($psCmdlet.ParameterSetName) | Out-Null
        build-dappinstaller @PSBoundParameters
        Remove-Module "build-dappinstaller"
        break
    }
    default {Write-Error "Unable to determine ParameterSetName"; break}
}

