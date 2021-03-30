<#
.Synopsis
   Get all tags

.DESCRIPTION
   -  Purpose: Get all tags
   -  Parameters: none
   -  Result on success: List of tags
   -  Result on failure: false|null
   Alias: Invoke-KBGetAllTags
.OUTPUTS
   Returns List of tags on success
   Returns false|null on failure
.NOTES
   API Function Name: getAllTags
   PS Module Safe Name: Invoke-KBGetAllTags
   Function parsed from: TagProcedure.php
   Description parsed from: tags_procedures.rst
#>
function Get-KBAllTags {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetAllTags')]
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
    method = 'getAllTags'
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


} # End Get-KBAllTags function

