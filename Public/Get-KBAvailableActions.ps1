<#
.Synopsis
   Get list of available automatic actions

.DESCRIPTION
   -  Purpose: Get list of available automatic actions
   -  Parameters: none
   -  Result on success: list of actions
   -  Result on failure: false
   Alias: Invoke-KBGetAvailableActions
.OUTPUTS
   Returns list of actions on success
   Returns false on failure
.NOTES
   API Function Name: getAvailableActions
   PS Module Safe Name: Invoke-KBGetAvailableActions
   Function parsed from: ActionProcedure.php
   Description parsed from: action_procedures.rst
#>
function Get-KBAvailableActions {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetAvailableActions')]
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
    method = 'getAvailableActions'
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


} # End Get-KBAvailableActions function

