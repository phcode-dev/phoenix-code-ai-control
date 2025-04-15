# PowerShell script for Phoenix AI Control Setup
# This should be saved as setup_phoenix_ai_control_win.ps1

# Function to display help
function Show-Help {
    Write-Host
    Write-Host "Phoenix AI Control Setup Script"
    Write-Host "-------------------------------"
    Write-Host "Usage:"
    Write-Host "    .\setup_phoenix_ai_control_win.ps1 [--managedByEmail <email>] [--allowedUsers <user1,user2,...>]"
    Write-Host
    Write-Host "Options:"
    Write-Host "    --managedByEmail   Optional but recommended. Admin email who manages AI policy. Can be used in your"
    Write-Host "                        Phoenix managed AI dashboard to selectively enable features and"
    Write-Host "                        manage usage quotas."
    Write-Host "    --allowedUsers     Optional. Comma-separated list of Windows usernames allowed to use AI."
    Write-Host "    --disableAI        Optional. If present, AI will be disabled by default."
    Write-Host "                        If not present, AI will be enabled."
    Write-Host
    Write-Host "Examples:"
    Write-Host "    .\setup_phoenix_ai_control_win.ps1 --managedByEmail admin@example.com"
    Write-Host "    .\setup_phoenix_ai_control_win.ps1 --allowedUsers Alice,Bob"
    Write-Host "    .\setup_phoenix_ai_control_win.ps1 --managedByEmail admin@example.com --allowedUsers Alice,Bob --disableAI"
    Write-Host
    Write-Host "Help:"
    Write-Host "    .\setup_phoenix_ai_control_win.ps1 --help"
    Write-Host
    Write-Host "Important:"
    Write-Host "    Running this script will overwrite any previous configuration."
    Write-Host "    Only the latest settings will be preserved."
    Write-Host
    
    exit 1
}

# Check if user has admin rights
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Process command-line arguments
function Process-Arguments {
    param (
        [string[]]$Arguments
    )
    
    $params = @{
        managedByEmail = $null
        allowedUsers = $null
        disableAI = $false
    }
    
    for ($i = 0; $i -lt $Arguments.Count; $i++) {
        switch ($Arguments[$i]) {
            "--help" {
                Show-Help
                break
            }
            "--managedByEmail" {
                $i++
                if ($i -ge $Arguments.Count) {
                    Write-Host "Error: Email address cannot be empty."
                    Write-Host "Example: --managedByEmail school.admin@example.edu"
                    exit 1
                }
                
                $email = $Arguments[$i]
                if ($email -eq "school.admin@example.edu") {
                    Write-Host "Error: Please enter a valid admin email address."
                    Write-Host "school.admin@example.edu is only meant as an example!"
                    exit 1
                }
                
                $params.managedByEmail = $email
                break
            }
            "--allowedUsers" {
                $i++
                if ($i -ge $Arguments.Count) {
                    Write-Host "Error: Allowed users list cannot be empty."
                    Write-Host "Example: --allowedUsers Alice,Bob"
                    exit 1
                }
                
                $params.allowedUsers = $Arguments[$i]
                break
            }
            "--disableAI" {
                $params.disableAI = $true
                break
            }
            default {
                Write-Host "Unknown option: $($Arguments[$i])"
                Show-Help
                break
            }
        }
    }
    
    return $params
}

# Check for help first, before admin check
if ($args -contains "--help") {
    Show-Help
}

# Check for admin privileges
if (-not (Test-Admin)) {
    Write-Host "This script must be run as Administrator."
    Write-Host "Please restart PowerShell as an administrator and try again."
    Write-Host "Run with --help for usage information."
    exit 1
}

# Process arguments
$params = Process-Arguments -Arguments $args

# Target directory and file
$targetDir = "C:\Program Files\Phoenix AI Control"
$configFile = Join-Path -Path $targetDir -ChildPath "config.json"

# Create directory if it doesn't exist
if (-not (Test-Path -Path $targetDir)) {
    New-Item -Path $targetDir -ItemType Directory | Out-Null
}

# Show config values
Write-Host
Write-Host "Configuration values:"
Write-Host "- Email: $($params.managedByEmail)"
Write-Host "- Allowed Users: $($params.allowedUsers)"
Write-Host "- Disable AI: $($params.disableAI)"
Write-Host

# Create the JSON content
$jsonContent = @{
    disableAI = $params.disableAI
}

if ($params.managedByEmail) {
    $jsonContent.managedByEmail = $params.managedByEmail
}

if ($params.allowedUsers) {
    $userList = $params.allowedUsers -split ","
    $jsonContent.allowedUsers = $userList
}

# Convert to JSON and write to file
$jsonString = $jsonContent | ConvertTo-Json
Set-Content -Path $configFile -Value $jsonString

# Set appropriate permissions - only Administrators can modify
$acl = Get-Acl -Path $configFile
$acl.SetAccessRuleProtection($true, $false) # Disable inheritance
$administratorsRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Administrators", "FullControl", "Allow"
)
$systemRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "SYSTEM", "FullControl", "Allow"
)
$everyoneRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Everyone", "ReadAndExecute", "Allow"
)
$acl.AddAccessRule($administratorsRule)
$acl.AddAccessRule($systemRule)
$acl.AddAccessRule($everyoneRule)
Set-Acl -Path $configFile -AclObject $acl

# Display results
Write-Host "Phoenix AI control config written to:"
Write-Host $configFile
Write-Host
Write-Host "Configuration contents:"
Write-Host "----------------------"
Get-Content -Path $configFile
Write-Host "----------------------"
Write-Host
Write-Host "NOTE: Running this script again will overwrite any previous configuration."
Write-Host "      Only the latest settings will be preserved."

# No need to create a batch wrapper