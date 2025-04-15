/**
 * Phoenix AI Control - Node.js component
 * Verifies AI control configuration for educational institutions
 *
 * To communicate between this node file and the phoenix extension use: NodeConnector-API -
 * See. https://docs.phcode.dev/api/API-Reference/NodeConnector for detailed docs.
 **/
console.log("Phoenix AI Control extension initialized");

const fs = require('fs');
const os = require('os');
const path = require('path');

const extnNodeConnector = global.createNodeConnector(
    "github-phcode-dev-phoenix-code-ai-control",
    exports
);

/**
 * Get the platform-specific config file path
 * @returns {string} The path to the config file
 */
function getConfigFilePath() {
    const platform = os.platform();

    if (platform === 'win32') {
        return 'C:\\Program Files\\Phoenix AI Control\\config.json';
    } else if (platform === 'darwin') {
        return '/Library/Application Support/Phoenix AI Control/config.json';
    } else if (platform === 'linux') {
        return '/etc/phoenix-ai-control/config.json';
    }

    throw new Error(`Unsupported platform: ${platform}`);
}

/**
 * Check if the current user is in the allowed users list
 * @param {Array<string>} allowedUsers - List of allowed usernames
 * @returns {boolean} True if current user is allowed
 */
function isCurrentUserAllowed(allowedUsers) {
    if (!allowedUsers || !Array.isArray(allowedUsers) || allowedUsers.length === 0) {
        return false;
    }

    const currentUser = os.userInfo().username;
    return allowedUsers.includes(currentUser);
}

/**
 * Get AI control configuration
 * @returns {Object} The configuration status and details
 */
async function getAIControlStatus() {
    try {
        const configFilePath = getConfigFilePath();

        // Check if config file exists
        if (!fs.existsSync(configFilePath)) {
            return {
                exists: false,
                isConfigured: false,
                isEnabled: true,
                message: "AI is currently enabled for all users. No control configuration found.",
                configPath: configFilePath
            };
        }

        // Read and parse config file
        const configContent = fs.readFileSync(configFilePath, 'utf8');
        const config = JSON.parse(configContent);

        const currentUser = os.userInfo().username;
        const platform = os.platform();
        let platformName = '';

        if (platform === 'win32') {
            platformName = 'Windows';
        } else if (platform === 'darwin') {
            platformName = 'macOS';
        } else if (platform === 'linux') {
            platformName = 'Linux';
        }

        // Check if AI is disabled globally
        if (config.disableAI === true) {
            // Check if current user is in allowed users list
            if (config.allowedUsers && isCurrentUserAllowed(config.allowedUsers)) {
                return {
                    exists: true,
                    isConfigured: true,
                    isEnabled: true,
                    message: `AI is enabled for user (${currentUser}) but disabled for others.`,
                    managedBy: config.managedByEmail || 'Not specified',
                    allowedUsers: config.allowedUsers || [],
                    currentUser: currentUser,
                    platform: platformName,
                    configPath: configFilePath
                };
            } else {
                return {
                    exists: true,
                    isConfigured: true,
                    isEnabled: false,
                    message: `AI is disabled by your system administrator.`,
                    managedBy: config.managedByEmail || 'Not specified',
                    allowedUsers: config.allowedUsers || [],
                    currentUser: currentUser,
                    platform: platformName,
                    configPath: configFilePath
                };
            }
        } else {
            // AI is enabled globally
            return {
                exists: true,
                isConfigured: true,
                isEnabled: true,
                message: `AI is enabled for all users.`,
                managedBy: config.managedByEmail || 'Not specified',
                allowedUsers: config.allowedUsers || [],
                currentUser: currentUser,
                platform: platformName,
                configPath: configFilePath
            };
        }
    } catch (error) {
        console.error('Error checking AI control:', error);
        return {
            exists: false,
            isConfigured: false,
            isEnabled: true,
            error: error.message,
            message: `Error checking AI configuration: ${error.message}`
        };
    }
}

exports.getAIControlStatus = getAIControlStatus;
