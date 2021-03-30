<#
.Synopsis
   Update a group

.DESCRIPTION
   -  Purpose: Update a group
   -  Parameters:
      -  group_id (integer, required)
      -  name (string, optional)
      -  external_id (string, optional)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBUpdateGroup
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: updateGroup
   PS Module Safe Name: Invoke-KBUpdateGroup
   Function parsed from: GroupProcedure.php
   Description parsed from: group_procedures.rst
#>
function Set-KBGroup {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBUpdateGroup')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$group_id,

    [string]$name,

    [string]$external_id,

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
$ApiParameters = @('group_id', 'name', 'external_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('group_id', 'name', 'external_id')
$hashjsonParameters = @{}

foreach ($par in $jsonParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashjsonParameters.Add($par, $PSBoundParameters[$par])
        }
    }

if ($PSCmdlet.ParameterSetName -eq 'PlainCredentials') {
    $Credential = New-KanboardCredential $ApiUri $ApiUsername $ApiPassword
    }
} # End begin block

End {
$jsonRequestId = Get-Random -Minimum 1 -Maximum ([int]::MaxValue)

$json = @{
    jsonrpc = '2.0'
    method = 'updateGroup'
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


} # End Set-KBGroup function

