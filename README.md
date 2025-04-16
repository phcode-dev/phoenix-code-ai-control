# Phoenix Code AI Control

🔐 Disable/Control AI features in Phoenix Code with deployment scripts for Windows, macOS, and Linux — made for schools and enterprise setups.

## AI Control Extension in Phoenix Code
### When AI is disabled
![Image](https://github.com/user-attachments/assets/6a066f62-a079-4ec9-bb93-9165fbf9bc99)
### AI is enabled for selected user, but disabled for others
![Image](https://github.com/user-attachments/assets/5f230107-854a-437f-952c-2712188f8ef2)

## Overview

Phoenix Code AI Control provides system administrators and users with tools to manage AI functionality in educational and enterprise environments. This repository contains:

- Installation scripts for Windows, macOS, and Linux
- Browser detection for AI availability

## Installation

### System Requirements

- Windows 10/11, macOS 10.15+, or Ubuntu/Debian-based Linux
- Administrative access for system-wide installation
- Phoenix Code Desktop or Browser version

### Installing Configuration Scripts

Configure AI controls by running the appropriate script for your platform:

> **Note:** The following scripts configure system-wide settings and do not require Phoenix Code to be installed on the administrator's machine.

Download and run the appropriate script for your platform [Download from this link.](https://github.com/phcode-dev/phoenix-code-ai-control/releases/latest/)

- For Windows: `setup_phoenix_ai_control_win.bat`
- For macOS: `setup_phoenix_ai_control_mac.sh`
- For Linux: `setup_phoenix_ai_control_linux.sh`

#### Windows Installation

1. Download the Windows Batch script:
   - `setup_phoenix_ai_control_win.bat`
2. Open Command Prompt as Administrator:
   - Press Win+X and select "Command Prompt (Admin)"
   - Navigate to the download location using `cd` command
3. Execute with parameters, for example:
   ```
   setup_phoenix_ai_control_win.bat --managedByEmail school.admin@example.edu --disableAI
   ```
   Note: The `--managedByEmail` parameter is optional but recommended

#### macOS Installation

1. Download the macOS script
2. Open Terminal and navigate to your download location
3. Run: `chmod +x setup_phoenix_ai_control_mac.sh`
4. Execute with parameters:
   ```
   sudo ./setup_phoenix_ai_control_mac.sh --managedByEmail school.admin@example.edu --disableAI
   ```
   Note: The `--managedByEmail` parameter is optional but recommended

#### Linux Installation

1. Download the Linux script
2. Open Terminal and navigate to your download location
3. Run: `chmod +x setup_phoenix_ai_control_linux.sh`
4. Execute with parameters:
   ```
   sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu --disableAI
   ```
   Note: The `--managedByEmail` parameter is optional but recommended

## Installation Script CLI Options

All installation scripts support the same command-line options:

| Option | Description |
|--------|-------------|
| `--help` | Display usage information and help text |
| `--managedByEmail <email>` | Optional but recommended. Admin email who manages AI policy. Can be used in your Phoenix managed AI dashboard to selectively enable features and manage usage quotas |
| `--allowedUsers "<user1,user2,...>"` | Comma-separated list of usernames allowed to use AI even when disabled for others. **IMPORTANT:** Always enclose the list in quotes to prevent parsing errors |
| `--disableAI` | If present, AI will be disabled by default for all users except those specified in `allowedUsers` |

## Disabling and Enabling AI

Here are quick examples for disabling and enabling AI on different platforms:

### Disabling AI

To disable AI for all users:

```bash
# Windows - in cmd(run as administrator)
setup_phoenix_ai_control_win.bat --disableAI --managedByEmail admin@example.com

# macOS - Terminal
sudo ./setup_phoenix_ai_control_mac.sh --disableAI --managedByEmail admin@example.com

# Linux - Bash
sudo ./setup_phoenix_ai_control_linux.sh --disableAI --managedByEmail admin@example.com
```

### Enabling AI

To enable AI for all users:

```bash
# Windows - in cmd(run as administrator)
setup_phoenix_ai_control_win.bat --managedByEmail admin@example.com

# macOS - Terminal
sudo ./setup_phoenix_ai_control_mac.sh --managedByEmail admin@example.com

# Linux - Bash
sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail admin@example.com
```

### Additional Examples

```bash
# Enable AI with administrative contact
sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu

# Enable AI for specific users only (IMPORTANT: always use quotes for multiple users)
sudo ./setup_phoenix_ai_control_linux.sh --allowedUsers "alice,bob" --disableAI

# Complete setup with all options
sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu --allowedUsers "alice,bob" --disableAI
```

> **Note:** Always replace `school.admin@example.edu` with an actual administrator email address. The scripts will detect and reject placeholder email addresses.

> **IMPORTANT:** When specifying multiple users with `--allowedUsers`, always enclose the comma-separated list in quotes (`"alice,bob"`) to prevent parsing errors on all platforms.

### Configuration File Locations

The scripts create configuration files in the following system-wide locations:

- **Windows**: `C:\Program Files\Phoenix AI Control\config.json`
- **macOS**: `/Library/Application Support/Phoenix AI Control/config.json`
- **Linux**: `/etc/phoenix-ai-control/config.json`

These files contain your configuration, including the optional but recommended `managedByEmail` field, and are created with read-only permissions for regular users. Only administrators can modify these files.

## Verifying AI Control Status

To verify the status of AI controls on end-user machines, the Phoenix Code AI Control extension must be installed:

### Installing the Extension

1. Open Phoenix Code
2. Navigate to File → Extension Manager
3. Search for "Phoenix Code AI Control"
4. Click the Install button
5. Restart Phoenix Code when prompted

### Checking Status in Desktop App

1. Open Phoenix Code
2. Navigate to View → AI Control Status
3. A dialog will appear showing your current configuration:
   - AI Status (Enabled/Disabled)
   - Platform information
   - Current user
   - Managed by (administrative contact)
   - List of allowed users (if configured)

### Checking Status in Browser Version

1. Open Phoenix Code in your web browser
2. Install the extension (File → Extension Manager → "Phoenix Code AI Control")
3. Navigate to View → AI Control Status
4. The browser will check if `ai.phcode.dev` is accessible:
   - First shows "Checking if AI is disabled..."
   - Then displays whether AI is available or blocked
   - Provides information on firewall configuration

## Configuration Options

### Desktop Applications (Recommended Method)

For desktop installations of Phoenix Code, we strongly recommend using the installation scripts described above. This approach provides:

1. System-wide configuration via protected config files
2. Granular control with user-level permissions
3. Ability to selectively enable AI for specific users

Only administrative users can modify this configuration.

### Network Blocking (For Browser Version at https://phcode.dev)

For schools using the browser version of Phoenix Code, network-level blocking is the recommended approach:

1. Block access to: `ai.phcode.dev`
2. Add this domain to your firewall or content filtering system

The browser version of Phoenix Code will automatically detect if the domain is unreachable and display appropriate status messages.

## FAQ

### When will AI be enabled in Phoenix Code?

Phoenix Code AI will be rolled out after May 20, 2025. Educational institutions should configure AI controls campus-wide before this date.

### How do I know if AI control is working?

In both the desktop and browser versions, go to View → AI Control Status to see a detailed report.

### Can I allow specific users to access AI features?

Yes, but only in the desktop version. Use the `--allowedUsers` parameter with a comma-separated list of usernames when running the installation script. These users will be able to access AI features even when disabled system-wide with the `--disableAI` flag.

### Is AI control mandatory?

No, AI control is optional and meant for educational institutions or enterprises that need to regulate AI usage. By default, all users have access to AI features.

### Will blocking AI affect other Phoenix Code features?

No, all other features of Phoenix Code will continue to work normally. Only the AI-powered features like code generation and explanations will be affected.

### How can I update the AI control configuration?

Simply run the installation script again with the new parameters. The script will overwrite the existing configuration file with your new settings.

### How do I re-enable AI after it has been disabled?

To re-enable AI that was previously disabled:

1. Run the installation script again without the `--disableAI` flag:
   ```bash
   # Windows - in cmd(run as administrator)
   setup_phoenix_ai_control_win.bat --managedByEmail school.admin@example.edu

   # macOS
   sudo ./setup_phoenix_ai_control_mac.sh --managedByEmail school.admin@example.edu

   # Linux
   sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu
   ```

2. For browser version, remove any firewall rules blocking `ai.phcode.dev`

### What's the difference between browser and desktop control?

- **Browser Version**: Only supports network-level blocking of `ai.phcode.dev` through your firewall
- **Desktop Version**: Provides comprehensive control through configuration files with user-specific permissions

### Does this completely prevent AI usage?

- **Desktop Version**: Yes, the control is comprehensive when properly configured using the installation scripts
- **Browser Version**: Only if you implement network-level blocking of the `ai.phcode.dev` domain

### How can I verify that the firewall is properly blocking AI access?

In the browser version, use the View → AI Control Status option which will attempt to connect to the AI service and report whether it's accessible or blocked.

### Can I disable AI for some users but enable it for others?

Yes, use the `--disableAI` flag to disable AI globally, then use the `--allowedUsers` parameter to specify which users should still have access. Example:
```bash
sudo ./setup_phoenix_ai_control_linux.sh --disableAI --allowedUsers "teacher1,admin2"
```

### Is there a way to monitor AI usage in my organization?

When you set the `--managedByEmail` parameter, this information is used for administration purposes. Future versions will provide a dashboard for administrators to monitor and manage AI usage across their organization.

## Support

For more information about controlling AI in educational institutions, visit:
[https://docs.phcode.dev/docs/control-ai](https://docs.phcode.dev/docs/control-ai)

## For Developers

To contribute to this project:

1. Clone the repository
2. Make your changes
3. Test on all supported platforms
4. Submit a pull request

## License

[MIT License](LICENSE)
