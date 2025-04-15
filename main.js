/**
 * Phoenix AI Control Extension
 * Verifies and displays the AI control configuration status for educational institutions.
 */

/*global define, brackets, $ */

// See detailed docs in https://docs.phcode.dev/api/creating-extensions
// A good place to look for code examples for extensions: https://github.com/phcode-dev/phoenix/tree/main/src/extensions/default

define(function (require, exports, module) {
    "use strict";

    // Brackets modules
    const AppInit = brackets.getModule("utils/AppInit"),
        DefaultDialogs = brackets.getModule("widgets/DefaultDialogs"),
        Dialogs = brackets.getModule("widgets/Dialogs"),
        CommandManager = brackets.getModule("command/CommandManager"),
        Menus = brackets.getModule("command/Menus"),
        NodeConnector = brackets.getModule("NodeConnector"),
        Mustache = brackets.getModule("thirdparty/mustache/mustache");

    // HTML Templates
    const browserMessageTemplate = require("text!./html/browser-message.html"),
        statusTemplate = require("text!./html/status-template.html"),
        errorTemplate = require("text!./html/error-template.html");

    let nodeConnector;

    // Function to run when the menu item is clicked
    async function checkAIControlStatus() {
        let html;

        if (!Phoenix.isNativeApp) {
            html = browserMessageTemplate;
        } else {
            try {
                // Call the nodeConnector to get AI control status
                const status = await nodeConnector.execPeer("getAIControlStatus");

                // Prepare view model for Mustache
                const viewModel = {
                    status: status,
                    showConfigDetails: status.exists && status.isConfigured,
                    hasAllowedUsers: status.allowedUsers && status.allowedUsers.length > 0,
                    allowedUsersList: status.allowedUsers ? status.allowedUsers.join(", ") : ""
                };

                // Render the template with Mustache
                html = Mustache.render(statusTemplate, viewModel);

            } catch (error) {
                console.error("Error checking AI control status:", error);

                // Render error template with Mustache
                html = Mustache.render(errorTemplate, {
                    errorMessage: error.message || "Unknown error"
                });
            }
        }

        Dialogs.showModalDialog(DefaultDialogs.DIALOG_ID_INFO, "Phoenix Code AI Control Status", html);
    }

    // Register command for AI Control Status check
    var AI_CONTROL_STATUS_ID = "phoenix.aiControlStatus";
    CommandManager.register("Check AI Control Status", AI_CONTROL_STATUS_ID, checkAIControlStatus);

    // Add menu item to File menu
    var menu = Menus.getMenu(Menus.AppMenuBar.FILE_MENU);
    menu.addMenuItem(AI_CONTROL_STATUS_ID);

    // Initialize extension once shell is finished initializing
    AppInit.appReady(function () {
        console.log("Phoenix AI Control extension initialized");

        if (Phoenix.isNativeApp) {
            nodeConnector = NodeConnector.createNodeConnector(
                "github-phcode-dev-phoenix-code-ai-control",
                exports
            );
        }
    });
});
