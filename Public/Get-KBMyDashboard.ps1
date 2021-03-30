<#
.Synopsis
   Get the dashboard of the logged user without pagination

.DESCRIPTION
   -  Purpose: Get the dashboard of the logged user without pagination
   -  Parameters: None
   -  Result on success: Dashboard information
   -  Result on failure: false
   Alias: Invoke-KBGetMyDashboard
.OUTPUTS
   Returns Dashboard information on success
   Returns false on failure
.NOTES
   API Function Name: getMyDashboard
   PS Module Safe Name: Invoke-KBGetMyDashboard
   Function parsed from: MeProcedure.php
   Description parsed from: me_procedures.rst
#>
function Get-KBMyDashboard {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetMyDashboard')]
Param (
    # Credential Object
    [Parameter(Mandatory=$true, ParameterSetName='CredentialObject')]
    $Credential,

    # Kanboard API Uri
    [Parameter(Mandatory=$true, ParameterSetName='PlainCredentials')]
    [string]$ApiUri,

    # API Username, use "jsonrpc" for the global access
    [Parameter(Mandatory=$true, ParameterSetName='PlainCredentials')]
    [string]$ApiUsername,

    # API Password or Token
    [Parameter(Mandatory=$true, ParameterSetName='PlainCredentials')]
    [Alias('Token')]
    [string]$ApiPassword
    )
Begin {
if ($PSCmdlet.ParameterSetName -eq 'PlainCredentials') {
    $Credential = New-KanboardCredential $ApiUri $ApiUsername $ApiPassword
    }
} # End begin block

End {
$jsonRequestId = Get-Random -Minimum 1 -Maximum ([int]::MaxValue)

$json = @{
    jsonrpc = '2.0'
    method = 'getMyDashboard'
    id = $jsonRequestId        
    }

# dynamically add user parameters
if ($hashJsonParameters.Count -gt 0) {
    $json.Add('params', $hashJsonParameters)
    }

$json = $json | ConvertTo-Json
    
if ($PSBoundParameters['Verbose']) {
    Write-Verbose $json
    }

$splat = @{
    Method = 'POST'
    Uri = $Credential.Uri
    Credential = $Credential.Credential
    Body = $json
    ContentType = 'application/json'
    }

$res = Invoke-RestMethod @splat

if ($res.result) {
    Convert-KanboardResult $res.result -PassThru
    }

} # End end block


} # End Get-KBMyDashboard function

