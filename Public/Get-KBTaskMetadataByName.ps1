<#
.Synopsis
   Get metadata related to a task by task unique id and metakey (name)

.DESCRIPTION
   -  Purpose: Get metadata related to a task by task unique id and
      metakey (name)
   -  Parameters:
      -  task_id (integer, required)
      -  name (string, required)
   -  Result on success: metadata value
   -  Result on failure: empty string
   Alias: Invoke-KBGetTaskMetadataByName
.OUTPUTS
   Returns metadata value on success
   Returns empty string on failure
.NOTES
   API Function Name: getTaskMetadataByName
   PS Module Safe Name: Invoke-KBGetTaskMetadataByName
   Function parsed from: TaskMetadataProcedure.php
   Description parsed from: task_metadata_procedures.rst
#>
function Get-KBTaskMetadataByName {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetTaskMetadataByName')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [Parameter(Mandatory=$true)]
    [string]$name,

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
$ApiParameters = @('task_id', 'name')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'name')
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
    method = 'getTaskMetadataByName'
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


} # End Get-KBTaskMetadataByName function

