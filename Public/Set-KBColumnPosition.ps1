<#
.Synopsis
   Change the column position

.DESCRIPTION
   -  Purpose: Change the column position
   -  Parameters:
      -  project_id (integer, required)
      -  column_id (integer, required)
      -  position (integer, required, must be >= 1)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBChangeColumnPosition
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: changeColumnPosition
   PS Module Safe Name: Invoke-KBChangeColumnPosition
   Function parsed from: ColumnProcedure.php
   Description parsed from: column_procedures.rst
#>
function Set-KBColumnPosition {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBChangeColumnPosition')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [Parameter(Mandatory=$true)]
    [int]$column_id,

    # must be >= 1
    [Parameter(Mandatory=$true)]
    [int]$position,

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
$ApiParameters = @('project_id', 'column_id', 'position')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'column_id', 'position')
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
    method = 'changeColumnPosition'
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


} # End Set-KBColumnPosition function

