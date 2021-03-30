<#
.Synopsis
   Update a subtask

.DESCRIPTION
   -  Purpose: Update a subtask
   -  Parameters:
      -  id (integer, required)
      -  task_id (integer, required)
      -  title (integer, optional)
      -  user_id (integer, optional)
      -  time_estimated (integer, optional)
      -  time_spent (integer, optional)
      -  status (integer, optional)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBUpdateSubtask
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: updateSubtask
   PS Module Safe Name: Invoke-KBUpdateSubtask
   Function parsed from: SubtaskProcedure.php
   Description parsed from: subtask_procedures.rst
#>
function Set-KBSubtask {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBUpdateSubtask')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$id,

    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [int]$title,

    [int]$user_id,

    [int]$time_estimated,

    [int]$time_spent,

    [int]$status,

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
$ApiParameters = @('id', 'task_id', 'title', 'user_id', 'time_estimated', 'time_spent', 'status')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('id', 'task_id', 'title', 'user_id', 'time_estimated', 'time_spent', 'status')
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
    method = 'updateSubtask'
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


} # End Set-KBSubtask function

