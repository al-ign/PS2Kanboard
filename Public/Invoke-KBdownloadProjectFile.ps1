<#
.Synopsis
   Download project file contents (encoded in base64)

.DESCRIPTION
   -  Purpose: Download project file contents (encoded in base64)
   -  Parameters:
      -  project_id (integer, required)
      -  file_id (integer, required)
   -  Result on success: base64 encoded string
   -  Result on failure: empty string
   Alias: Invoke-KBDownloadProjectFile, Get-KBProjectFileDownload
.OUTPUTS
   Returns base64 encoded string on success
   Returns empty string on failure
.NOTES
   API Function Name: downloadProjectFile
   PS Module Safe Name: Invoke-KBDownloadProjectFile
   Function parsed from: ProjectFileProcedure.php
   Description parsed from: project_file_procedures.rst
#>
function Invoke-KBdownloadProjectFile {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBDownloadProjectFile', 'Get-KBProjectFileDownload')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$project_id,

    [Parameter(Mandatory=$true)]
    [int]$file_id,

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
$ApiParameters = @('project_id', 'file_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('project_id', 'file_id')
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
    method = 'downloadProjectFile'
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


} # End Invoke-KBdownloadProjectFile function

