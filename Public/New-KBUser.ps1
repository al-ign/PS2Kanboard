<#
.Synopsis
   Create a new user

.DESCRIPTION
   -  Purpose: Create a new user
   -  Parameters:
      -  username Must be unique (string, required)
      -  password Must have at least 6 characters (string, required)
      -  name (string, optional)
      -  email (string, optional)
      -  role (string, optional, example: app-admin, app-manager,
         app-user)
   -  Result on success: user_id
   -  Result on failure: false
   Alias: Invoke-KBCreateUser
.OUTPUTS
   Returns user_id on success
   Returns false on failure
.NOTES
   API Function Name: createUser
   PS Module Safe Name: Invoke-KBCreateUser
   Function parsed from: UserProcedure.php
   Description parsed from: user_procedures.rst
#>
function New-KBUser {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBCreateUser')]
Param (
    # Must be unique 
    [Parameter(Mandatory=$true)]
    [string]$username,

    # Must have at least 6 characters 
    [Parameter(Mandatory=$true)]
    [string]$password,

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
$ApiParameters = @('username', 'password', 'name', 'email', 'role')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('username', 'password', 'name', 'email', 'role')
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
    method = 'createUser'
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


} # End New-KBUser function

