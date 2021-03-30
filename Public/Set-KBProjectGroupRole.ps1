<#
.Synopsis
   Change role of a group for a project

.DESCRIPTION
   -  Purpose: Change role of a group for a project
   -  Parameters:
      -  project_id (integer, required)
      -  group_id (integer, required)
      -  role (string, required)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBChangeProjectGroupRole
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: changeProjectGroupRole
   PS Module Safe Name: Invoke-KBChangeProjectGroupRole
   Function parsed from: ProjectPermissionProcedure.php
   Description parsed from: project_permission_procedures.rst
#>
function Set-KBProjectGroupRole {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBChangeProjectGroupRole')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [Parameter(Mandatory=$true)]
    [int]$group_id,

    [Parameter(Mandatory=$true)]
    [string]$role,

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
$ApiParameters = @('project_id', 'group_id', 'role')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'group_id', 'role')
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
    method = 'changeProjectGroupRole'
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


} # End Set-KBProjectGroupRole function

