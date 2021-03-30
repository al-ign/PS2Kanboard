<#
.Synopsis
   Update a task

.DESCRIPTION
   -  Purpose: Update a task
   -  Parameters:
      -  id (integer, required)
      -  title (string, optional)
      -  color_id (string, optional)
      -  owner_id (integer, optional)
      -  date_due: ISO8601 format (string, optional)
      -  description Markdown content (string, optional)
      -  category_id (integer, optional)
      -  score (integer, optional)
      -  priority (integer, optional)
      -  recurrence_status (integer, optional)
      -  recurrence_trigger (integer, optional)
      -  recurrence_factor (integer, optional)
      -  recurrence_timeframe (integer, optional)
      -  recurrence_basedate (integer, optional)
      -  reference (string, optional)
      -  tags ([]string, optional)
      -  date_started: ISO8601 format (string, optional)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBUpdateTask
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: updateTask
   PS Module Safe Name: Invoke-KBUpdateTask
   Function parsed from: TaskProcedure.php
   Description parsed from: task_procedures.rst
#>
function Set-KBTask {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBUpdateTask')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$id,

    [string]$title,

    [string]$color_id,

    [int]$owner_id,

    # ISO8601 format 
    [string]$date_due,

    # Markdown content 
    [string]$description,

    [int]$category_id,

    [int]$score,

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
$ApiParameters = @('id', 'title', 'color_id', 'owner_id', 'date_due', 'description', 'category_id', 'score', 'priority', 'recurrence_status', 'recurrence_trigger', 'recurrence_factor', 'recurrence_timeframe', 'recurrence_basedate', 'reference', 'tags', 'date_started', 'time_spent', 'time_estimated')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('id', 'title', 'color_id', 'owner_id', 'date_due', 'description', 'category_id', 'score', 'priority', 'recurrence_status', 'recurrence_trigger', 'recurrence_factor', 'recurrence_timeframe', 'recurrence_basedate', 'reference', 'tags', 'date_started', 'time_spent', 'time_estimated')
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
    method = 'updateTask'
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


} # End Set-KBTask function

