<#
.Synopsis
   Update external task link

.DESCRIPTION
   -  Purpose: Update external task link
   -  Parameters:
      -  task_id (integer, required)
      -  link_id (integer, required)
      -  title (string, required)
      -  url (string, required)
      -  dependency (string, optional)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBUpdateExternalTaskLink
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: updateExternalTaskLink
   PS Module Safe Name: Invoke-KBUpdateExternalTaskLink
   Function parsed from: TaskExternalLinkProcedure.php
   Description parsed from: external_task_link_procedures.rst
#>
function Set-KBExternalTaskLink {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBUpdateExternalTaskLink')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [Parameter(Mandatory=$true)]
    [int]$link_id,

    [Parameter(Mandatory=$true)]
    [string]$title,

    [Parameter(Mandatory=$true)]
    [string]$url,

    [string]$dependency,

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
$ApiParameters = @('task_id', 'link_id', 'title', 'url', 'dependency')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'link_id', 'title', 'url', 'dependency')
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
    method = 'updateExternalTaskLink'
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


} # End Set-KBExternalTaskLink function

