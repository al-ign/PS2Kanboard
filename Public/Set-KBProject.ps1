<#
.Synopsis
   Update a project

.DESCRIPTION
   -  Purpose: Update a project
   -  Parameters:
      -  project_id (integer, required)
      -  name (string, optional)
      -  description (string, optional)
      -  owner_id (integer, optional)
      -  identifier (string, optional)
      -  start_date ISO8601 format (string, optional)
      -  end_date ISO8601 format (string, optional)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBUpdateProject
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: updateProject
   PS Module Safe Name: Invoke-KBUpdateProject
   Function parsed from: ProjectProcedure.php
   Description parsed from: project_procedures.rst
#>
function Set-KBProject {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBUpdateProject')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [string]$name,

    [string]$description,

    [int]$owner_id,

    [string]$identifier,

    # ISO8601 format 
    [string]$start_date,

    # ISO8601 format 
    [string]$end_date,

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
$ApiParameters = @('project_id', 'name', 'description', 'owner_id', 'identifier', 'start_date', 'end_date')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'name', 'description', 'owner_id', 'identifier', 'start_date', 'end_date')
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
    method = 'updateProject'
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


} # End Set-KBProject function

