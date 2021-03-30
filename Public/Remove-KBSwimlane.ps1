<#
.Synopsis
   Remove a swimlane

.DESCRIPTION
   -  Purpose: Remove a swimlane
   -  Parameters:
      -  project_id (integer, required)
      -  swimlane_id (integer, required)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBRemoveSwimlane
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: removeSwimlane
   PS Module Safe Name: Invoke-KBRemoveSwimlane
   Function parsed from: SwimlaneProcedure.php
   Description parsed from: swimlane_procedures.rst
#>
function Remove-KBSwimlane {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBRemoveSwimlane')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [Parameter(Mandatory=$true)]
    [int]$swimlane_id,

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
$ApiParameters = @('project_id', 'swimlane_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'swimlane_id')
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
    method = 'removeSwimlane'
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


} # End Remove-KBSwimlane function

