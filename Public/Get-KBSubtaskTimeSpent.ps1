<#
.Synopsis
   Get time spent on a subtask for a user

.DESCRIPTION
   -  Purpose: Get time spent on a subtask for a user
   -  Parameters:
      -  subtask_id (integer, required)
      -  user_id (integer, optional)
   -  Result on success: number of hours
   -  Result on failure: false
   Alias: Invoke-KBGetSubtaskTimeSpent
.OUTPUTS
   Returns number of hours on success
   Returns false on failure
.NOTES
   API Function Name: getSubtaskTimeSpent
   PS Module Safe Name: Invoke-KBGetSubtaskTimeSpent
   Function parsed from: SubtaskTimeTrackingProcedure.php
   Description parsed from: subtask_time_tracking_procedures.rst
#>
function Get-KBSubtaskTimeSpent {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetSubtaskTimeSpent')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$subtask_id,

    [int]$user_id,

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
$ApiParameters = @('subtask_id', 'user_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('subtask_id', 'user_id')
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
    method = 'getSubtaskTimeSpent'
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


} # End Get-KBSubtaskTimeSpent function

