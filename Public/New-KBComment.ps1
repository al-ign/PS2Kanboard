<#
.Synopsis
   Create a new comment

.DESCRIPTION
   -  Purpose: Create a new comment
   -  Parameters:
      -  task_id (integer, required)
      -  user_id (integer, required)
      -  content Markdown content (string, required)
   -  Result on success: comment_id
   -  Result on failure: false
   Alias: Invoke-KBCreateComment
.OUTPUTS
   Returns comment_id on success
   Returns false on failure
.NOTES
   API Function Name: createComment
   PS Module Safe Name: Invoke-KBCreateComment
   Function parsed from: CommentProcedure.php
   Description parsed from: comment_procedures.rst
#>
function New-KBComment {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBCreateComment')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$task_id,

    [Parameter(Mandatory=$true)]
    [int]$user_id,

    # Markdown content 
    [Parameter(Mandatory=$true)]
    [string]$content,

    $reference,

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
$ApiParameters = @('task_id', 'user_id', 'content', 'reference')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('task_id', 'user_id', 'content', 'reference')
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
    method = 'createComment'
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


} # End New-KBComment function

