<#
.Synopsis
   Save/update task metadata

.DESCRIPTION
   -  Purpose: Save/update task metadata
   -  Parameters:
      -  task_id (integer, required)
      -  values (array, required)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBSaveTaskMetadata
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: saveTaskMetadata
   PS Module Safe Name: Invoke-KBSaveTaskMetadata
   Function parsed from: TaskMetadataProcedure.php
   Description parsed from: task_metadata_procedures.rst
#>
function Set-KBTaskMetadata {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBSaveTaskMetadata')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    # array
    [Parameter(Mandatory=$true)]
    $values,

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
$ApiParameters = @('task_id', 'values')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'values')
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
    method = 'saveTaskMetadata'
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


} # End Set-KBTaskMetadata function

