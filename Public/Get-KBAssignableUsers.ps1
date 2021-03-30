<#
.Synopsis
   Get users that can be assigned to a task for a project (all members except viewers)

.DESCRIPTION
   -  Purpose: Get users that can be assigned to a task for a project
      (all members except viewers)
   -  Parameters:
      -  project_id (integer, required)
      -  prepend_unassigned (boolean, optional, default is false)
   -  Result on success: Dictionary of user_id => user name
   -  Result on failure: false
   Alias: Invoke-KBGetAssignableUsers
.OUTPUTS
   Returns Dictionary of user_id => user name on success
   Returns false on failure
.NOTES
   API Function Name: getAssignableUsers
   PS Module Safe Name: Invoke-KBGetAssignableUsers
   Function parsed from: ProjectPermissionProcedure.php
   Description parsed from: project_permission_procedures.rst
#>
function Get-KBAssignableUsers {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBGetAssignableUsers')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    # default is false
    [bool]$prepend_unassigned,

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
$ApiParameters = @('project_id', 'prepend_unassigned')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'prepend_unassigned')
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
    method = 'getAssignableUsers'
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


} # End Get-KBAssignableUsers function

