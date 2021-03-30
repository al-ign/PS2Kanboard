<#
.Synopsis
   Get projects of connected user with full details

.DESCRIPTION
   -  Purpose: Get projects of connected user with full details
   -  Parameters:
      -  none
   -  Result on success: List of projects with details
   -  Result on failure: false
   Alias: Invoke-KBGetMyProjects
.OUTPUTS
   Returns List of projects with details on success
   Returns false on failure
.NOTES
   API Function Name: getMyProjects
   PS Module Safe Name: Invoke-KBGetMyProjects
   Function parsed from: MeProcedure.php
   Description parsed from: me_procedures.rst
#>
function Get-KBMyProjects {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetMyProjects')]
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
    method = 'getMyProjects'
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


} # End Get-KBMyProjects function

