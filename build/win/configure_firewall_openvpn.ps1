
<#
.SYNOPSIS
    Add Windows firewall rule for OpenVPN server.
.DESCRIPTION
    Add Windows firewall rule for OpenVPN server.

.PARAMETER UserRole
    User role. Used solely for better naming and grouping in firewall rules list.

.PARAMETER ServiceName
    Name of service. Used for consitent naming between windows service and firewall rule.

.PARAMETER ProgramPath
    Path to binary

.PARAMETER Port
    Port number to allow through firewall

.PARAMETER Protocol
    Protocol. can be udp or tcp

.EXAMPLE
    .\configure_firewall_openvpn.ps1 -UserRole agent -ServiceName "Privatix_openvpn_server_7b1f782b82f83be7f7eb024def947bc214fa79a3" -ProgramPath "C:\Program Files\Privatix\Agent\73e17130-2a1d-4f7d-97a8-93a9aaa6f10d\bin\openvpn\openvpn.exe" -Port 443 -Protocol tcp

    Description
    -----------
    Allow payments to be recieved by dappctrl through windows firewall
#>
param (
    [ValidateSet('agent', 'client')]
    [string]$UserRole,
    [ValidateNotNullOrEmpty()]
    [string]$ServiceName,
    [ValidateScript( {Test-Path $_ })]
    [string]$ProgramPath,
    [ValidateRange(0, 65535)] 
    [int]$Port,
    [ValidateSet('tcp', 'udp')]
    [string]$Protocol = 'tcp'
)
New-NetFirewallRule -PolicyStore PersistentStore -Name $ServiceName -DisplayName "Privatix OpenVPN server" -Description "Inbound rule for Privatix OpenVPN server" -Group "Privatix $UserRole" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort $Port -Protocol $Protocol -Program $ProgramPath
