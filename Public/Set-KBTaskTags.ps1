<#
.Synopsis
   Assign/Create/Update tags for a task

.DESCRIPTION
   -  Purpose: Assign/Create/Update tags for a task
   -  Parameters:
      -  project_id (integer)
      -  task_id (integer)
      -  tags List of tags ([]string)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBSetTaskTags
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: setTaskTags
   PS Module Safe Name: Invoke-KBSetTaskTags
   Function parsed from: TaskTagProcedure.php
   Description parsed from: tags_procedures.rst
#>
function Set-KBTaskTags {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBSetTaskTags')]
Param (
    [int]$project_id,

    [int]$task_id,

    # List of tags 
    [string[]]$tags,

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
$ApiParameters = @('project_id', 'task_id', 'tags')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'task_id', 'tags')
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
    method = 'setTaskTags'
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


} # End Set-KBTaskTags function

