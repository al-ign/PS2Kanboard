<#
.Synopsis
   Move a task to another column or another position

.DESCRIPTION
   -  Purpose: Move a task to another column or another position
   -  Parameters:
      -  task_id (integer, required)
      -  project_id (integer, required)
      -  swimlane_id (integer, optional)
      -  column_id (integer, optional)
      -  category_id (integer, optional)
      -  owner_id (integer, optional)
   -  Result on success: task_id
   -  Result on failure: false
   Alias: Invoke-KBDuplicateTaskToProject, Duplicate-KBTaskToProject
.OUTPUTS
   Returns task_id on success
   Returns false on failure
.NOTES
   API Function Name: duplicateTaskToProject
   PS Module Safe Name: Invoke-KBDuplicateTaskToProject
   Function parsed from: TaskProcedure.php
   Description parsed from: task_procedures.rst
#>
function Copy-KBTaskToProject {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBDuplicateTaskToProject', 'Duplicate-KBTaskToProject')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [int]$swimlane_id,

    [int]$column_id,

    [int]$category_id,

    [int]$owner_id,

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
$ApiParameters = @('task_id', 'project_id', 'swimlane_id', 'column_id', 'category_id', 'owner_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'project_id', 'swimlane_id', 'column_id', 'category_id', 'owner_id')
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
    method = 'duplicateTaskToProject'
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


} # End Copy-KBTaskToProject function

