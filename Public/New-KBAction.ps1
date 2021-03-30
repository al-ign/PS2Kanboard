<#
.Synopsis
   Create an action

.DESCRIPTION
   -  Purpose: Create an action
   -  Parameters:
      -  project_id (integer, required)
      -  event_name (string, required)
      -  action_name (string, required)
      -  params (key/value parameters, required)
   -  Result on success: action_id
   -  Result on failure: false
   Alias: Invoke-KBCreateAction
.OUTPUTS
   Returns action_id on success
   Returns false on failure
.NOTES
   API Function Name: createAction
   PS Module Safe Name: Invoke-KBCreateAction
   Function parsed from: ActionProcedure.php
   Description parsed from: action_procedures.rst
#>
function New-KBAction {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBCreateAction')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [Parameter(Mandatory=$true)]
    [string]$event_name,

    [Parameter(Mandatory=$true)]
    [string]$action_name,

    # key/value parameters
    [Parameter(Mandatory=$true)]
    $params,

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
$ApiParameters = @('project_id', 'event_name', 'action_name', 'params')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'event_name', 'action_name', 'params')
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
    method = 'createAction'
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


} # End New-KBAction function

