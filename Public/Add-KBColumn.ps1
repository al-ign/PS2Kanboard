<#
.Synopsis
   Add a new column

.DESCRIPTION
   -  Purpose: Add a new column
   -  Parameters:
      -  project_id (integer, required)
      -  title (string, required)
      -  task_limit (integer, optional)
      -  description (string, optional)
   -  Result on success: column_id
   -  Result on failure: false
   Alias: Invoke-KBAddColumn
.OUTPUTS
   Returns column_id on success
   Returns false on failure
.NOTES
   API Function Name: addColumn
   PS Module Safe Name: Invoke-KBAddColumn
   Function parsed from: ColumnProcedure.php
   Description parsed from: column_procedures.rst
#>
function Add-KBColumn {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBAddColumn')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [Parameter(Mandatory=$true)]
    [string]$title,

    [int]$task_limit,

    [string]$description,

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
$ApiParameters = @('project_id', 'title', 'task_limit', 'description')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'title', 'task_limit', 'description')
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
    method = 'addColumn'
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


} # End Add-KBColumn function

