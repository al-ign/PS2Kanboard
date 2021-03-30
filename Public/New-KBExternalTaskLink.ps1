<#
.Synopsis
   Create a new external link

.DESCRIPTION
   -  Purpose: Create a new external link
   -  Parameters:
      -  task_id (integer, required)
      -  url (string, required)
      -  dependency (string, required)
      -  type (string, optional)
      -  title (string, optional)
   -  Result on success: link_id
   -  Result on failure: false
   Alias: Invoke-KBCreateExternalTaskLink
.OUTPUTS
   Returns link_id on success
   Returns false on failure
.NOTES
   API Function Name: createExternalTaskLink
   PS Module Safe Name: Invoke-KBCreateExternalTaskLink
   Function parsed from: TaskExternalLinkProcedure.php
   Description parsed from: external_task_link_procedures.rst
#>
function New-KBExternalTaskLink {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBCreateExternalTaskLink')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [Parameter(Mandatory=$true)]
    [string]$url,

    [Parameter(Mandatory=$true)]
    [string]$dependency,

    [string]$type,

    [string]$title,

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
$ApiParameters = @('task_id', 'url', 'dependency', 'type', 'title')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'url', 'dependency', 'type', 'title')
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
    method = 'createExternalTaskLink'
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


} # End New-KBExternalTaskLink function

