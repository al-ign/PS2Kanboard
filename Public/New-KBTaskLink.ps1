<#
.Synopsis
   Create a link between two tasks

.DESCRIPTION
   -  Purpose: Create a link between two tasks
   -  Parameters:
      -  task_id (integer, required)
      -  opposite_task_id (integer, required)
      -  link_id (integer, required)
   -  Result on success: task_link_id
   -  Result on failure: false
   Alias: Invoke-KBCreateTaskLink
.OUTPUTS
   Returns task_link_id on success
   Returns false on failure
.NOTES
   API Function Name: createTaskLink
   PS Module Safe Name: Invoke-KBCreateTaskLink
   Function parsed from: TaskLinkProcedure.php
   Description parsed from: internal_task_link_procedures.rst
#>
function New-KBTaskLink {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBCreateTaskLink')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [Parameter(Mandatory=$true)]
    [int]$opposite_task_id,

    [Parameter(Mandatory=$true)]
    [int]$link_id,

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
$ApiParameters = @('task_id', 'opposite_task_id', 'link_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'opposite_task_id', 'link_id')
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
    method = 'createTaskLink'
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


} # End New-KBTaskLink function

