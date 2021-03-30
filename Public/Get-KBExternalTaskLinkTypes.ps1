<#
.Synopsis
   Get all registered external link providers

.DESCRIPTION
   -  Purpose: Get all registered external link providers
   -  Parameters: none
   -  Result on success: dict
   -  Result on failure: false
   Alias: Invoke-KBGetExternalTaskLinkTypes
.OUTPUTS
   Returns dict on success
   Returns false on failure
.NOTES
   API Function Name: getExternalTaskLinkTypes
   PS Module Safe Name: Invoke-KBGetExternalTaskLinkTypes
   Function parsed from: TaskExternalLinkProcedure.php
   Description parsed from: external_task_link_procedures.rst
#>
function Get-KBExternalTaskLinkTypes {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetExternalTaskLinkTypes')]
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
    method = 'getExternalTaskLinkTypes'
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


} # End Get-KBExternalTaskLinkTypes function

