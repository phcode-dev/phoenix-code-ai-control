# Phoenix Code AI Control

🔐 Control AI features in Phoenix Code with deployment scripts for Windows, macOS, and Linux — made for schools and enterprise setups.

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

Download and run the appropriate script for your platform:

- [Windows Script](https://download.phcode.dev/ai-control/setup_phoenix_ai_control_win.bat)
- [macOS Script](https://download.phcode.dev/ai-control/setup_phoenix_ai_control_mac.sh)
- [Linux Script](https://download.phcode.dev/ai-control/setup_phoenix_ai_control_linux.sh)

#### Windows Installation

1. Download the Windows script
2. Right-click and select "Run as administrator"
3. Execute with required parameters, for example:
   ```
   setup_phoenix_ai_control_win.bat --managedByEmail school.admin@example.edu --disableAI
   ```

#### macOS Installation

1. Download the macOS script
2. Open Terminal and navigate to your download location
3. Run: `chmod +x setup_phoenix_ai_control_mac.sh`
4. Execute with required parameters:
   ```
   sudo ./setup_phoenix_ai_control_mac.sh --managedByEmail school.admin@example.edu --disableAI
   ```

#### Linux Installation

1. Download the Linux script
2. Open Terminal and navigate to your download location
3. Run: `chmod +x setup_phoenix_ai_control_linux.sh`
4. Execute with required parameters:
   ```
   sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu --disableAI
   ```

## Installation Script CLI Options

All installation scripts support the same command-line options:

| Option | Description |
|--------|-------------|
| `--help` | Display usage information and help text |
| `--managedByEmail <email>` | Admin email who manages AI policy. Can be used in your Phoenix managed AI dashboard to selectively enable features and manage usage quotas |
| `--allowedUsers <user1,user2,...>` | Comma-separated list of usernames allowed to use AI even when disabled for others |
| `--disableAI` | If present, AI will be disabled by default for all users except those specified in `allowedUsers` |

### Example Usage

```bash
# Enable AI with administrative contact
sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu

# Enable AI for specific users only
sudo ./setup_phoenix_ai_control_linux.sh --allowedUsers alice,bob --disableAI

# Complete setup with all options
sudo ./setup_phoenix_ai_control_linux.sh --managedByEmail school.admin@example.edu --allowedUsers alice,bob --disableAI
```

> **Note:** Always replace `school.admin@example.edu` with an actual administrator email address. The scripts will detect and reject placeholder email addresses.

### Configuration File Locations

The scripts create configuration files in the following system-wide locations:

- **Windows**: `C:\Program Files\Phoenix AI Control\config.json`
- **macOS**: `/Library/Application Support/Phoenix AI Control/config.json`
- **Linux**: `/etc/phoenix-ai-control/config.json`

These files are created with read-only permissions for regular users and can only be modified by administrators.

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
2. Navigate to File → Check AI Control Status
3. A dialog will appear showing your current configuration:
   - AI Status (Enabled/Disabled)
   - Platform information
   - Current user
   - Managed by (administrative contact)
   - List of allowed users (if configured)

### Checking Status in Browser Version

1. Open Phoenix Code in your web browser
2. Install the extension (File → Extension Manager → "Phoenix Code AI Control")
3. Navigate to File → Check AI Control Status
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

### How do I know if AI control is working?

In both the desktop and browser versions, go to File → Check AI Control Status to see a detailed report.

### Can I allow specific users to access AI features?

Yes, but only in the desktop version. Use the `--allowedUsers` parameter with a comma-separated list of usernames when running the installation script. These users will be able to access AI features even when disabled system-wide with the `--disableAI` flag.

### Is AI control mandatory?

No, AI control is optional and meant for educational institutions or enterprises that need to regulate AI usage. By default, all users have access to AI features.

### Will blocking AI affect other Phoenix Code features?

No, all other features of Phoenix Code will continue to work normally. Only the AI-powered features like code generation and explanations will be affected.

### How can I update the AI control configuration?

Simply run the installation script again with the new parameters. The script will overwrite the existing configuration file with your new settings.

### What's the difference between browser and desktop control?

- **Browser Version**: Only supports network-level blocking of `ai.phcode.dev` through your firewall
- **Desktop Version**: Provides comprehensive control through configuration files with user-specific permissions

### Does this completely prevent AI usage?

- **Desktop Version**: Yes, the control is comprehensive when properly configured using the installation scripts
- **Browser Version**: Only if you implement network-level blocking of the `ai.phcode.dev` domain

### How can I verify that the firewall is properly blocking AI access?

In the browser version, use the "Check AI Control Status" option which will attempt to connect to the AI service and report whether it's accessible or blocked.

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
