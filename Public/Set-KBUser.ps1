<#
.Synopsis
   Update a user

.DESCRIPTION
   -  Purpose: Update a user
   -  Parameters:
      -  id (integer)
      -  username (string, optional)
      -  name (string, optional)
      -  email (string, optional)
      -  role (string, optional, example: app-admin, app-manager,
         app-user)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBUpdateUser
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: updateUser
   PS Module Safe Name: Invoke-KBUpdateUser
   Function parsed from: UserProcedure.php
   Description parsed from: user_procedures.rst
#>
function Set-KBUser {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBUpdateUser')]
Param (
    [int]$id,

    [string]$username,

    [string]$name,

    [string]$email,

    # example: app-admin, app-manager, app-user
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
$ApiParameters = @('id', 'username', 'name', 'email', 'role')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('id', 'username', 'name', 'email', 'role')
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
    method = 'updateUser'
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


} # End Set-KBUser function

