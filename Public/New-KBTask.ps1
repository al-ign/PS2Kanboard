<#
.Synopsis
   Create a new task

.DESCRIPTION
   -  Purpose: Create a new task
   -  Parameters:
      -  title (string, required)
      -  project_id (integer, required)
      -  color_id (string, optional)
      -  column_id (integer, optional)
      -  owner_id (integer, optional)
      -  creator_id (integer, optional)
      -  date_due: ISO8601 format (string, optional)
      -  description Markdown content (string, optional)
      -  category_id (integer, optional)
      -  score (integer, optional)
      -  swimlane_id (integer, optional)
      -  priority (integer, optional)
      -  recurrence_status (integer, optional)
      -  recurrence_trigger (integer, optional)
      -  recurrence_factor (integer, optional)
      -  recurrence_timeframe (integer, optional)
      -  recurrence_basedate (integer, optional)
      -  reference (string, optional)
      -  tags ([]string, optional)
      -  date_started: ISO8601 format (string, optional)
   -  Result on success: task_id
   -  Result on failure: false
   Alias: Invoke-KBCreateTask
.OUTPUTS
   Returns task_id on success
   Returns false on failure
.NOTES
   API Function Name: createTask
   PS Module Safe Name: Invoke-KBCreateTask
   Function parsed from: TaskProcedure.php
   Description parsed from: task_procedures.rst
#>
function New-KBTask {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBCreateTask')]
Param (
    [Parameter(Mandatory=$true)]
    [string]$title,

    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [string]$color_id,

    [int]$column_id,

    [int]$owner_id,

    [int]$creator_id,

    # ISO8601 format 
    [string]$date_due,

    # Markdown content 
    [string]$description,

    [int]$category_id,

    [int]$score,

    [int]$swimlane_id,

    [int]$priority,

    [int]$recurrence_status,

    [int]$recurrence_trigger,

    [int]$recurrence_factor,

    [int]$recurrence_timeframe,

    [int]$recurrence_basedate,

    [string]$reference,

    [string[]]$tags,

    # ISO8601 format 
    [string]$date_started,

    $time_spent,

    $time_estimated,

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
$ApiParameters = @('title', 'project_id', 'color_id', 'column_id', 'owner_id', 'creator_id', 'date_due', 'description', 'category_id', 'score', 'swimlane_id', 'priority', 'recurrence_status', 'recurrence_trigger', 'recurrence_factor', 'recurrence_timeframe', 'recurrence_basedate', 'reference', 'tags', 'date_started', 'time_spent', 'time_estimated')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('title', 'project_id', 'color_id', 'column_id', 'owner_id', 'creator_id', 'date_due', 'description', 'category_id', 'score', 'swimlane_id', 'priority', 'recurrence_status', 'recurrence_trigger', 'recurrence_factor', 'recurrence_timeframe', 'recurrence_basedate', 'reference', 'tags', 'date_started', 'time_spent', 'time_estimated')
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
    method = 'createTask'
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


} # End New-KBTask function

