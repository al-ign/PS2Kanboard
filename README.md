# PS2Kanboard
Kanboard API module for PowerShell

# Usage

    $cred = @{
        Credential = New-KanboardCredential https://kanboard.example.org/jsonrpc.php jsonrpc 44a767f47c8bf7885f6d0a8b052445f9d2615ed3350d1452e3babaa860b2
        }

    Get-KBAllProjects @cred 
	
