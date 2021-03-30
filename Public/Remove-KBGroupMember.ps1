<#
.Synopsis
   Remove a user from a group

.DESCRIPTION
   -  Purpose: Remove a user from a group
   -  Parameters:
      -  group_id (integer, required)
      -  user_id (integer, required)
   -  Result on success: true
   -  Result on failure: false
   Alias: Invoke-KBRemoveGroupMember
.OUTPUTS
   Returns true on success
   Returns false on failure
.NOTES
   API Function Name: removeGroupMember
   PS Module Safe Name: Invoke-KBRemoveGroupMember
   Function parsed from: GroupMemberProcedure.php
   Description parsed from: group_member_procedures.rst
#>
function Remove-KBGroupMember {
[CmdletBinding(DefaultParameterSetName='PlainCredentials')]
[Alias('Invoke-KBRemoveGroupMember')]
Param (
    [Parameter(Mandatory=$true)]
    [int]$group_id,

    [Parameter(Mandatory=$true)]
    [int]$user_id,

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
$ApiParameters = @('group_id', 'user_id')
$hashApiParameters = @{}

foreach ($par in $hashApiParameters) {
    if ($PSBoundParameters.Keys -contains $par) {
        $hashApiParameters.Add($par, $PSBoundParameters[$par])
        }
    }

$jsonParameters = @('group_id', 'user_id')
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
    method = 'removeGroupMember'
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


} # End Remove-KBGroupMember function

