/**
 * A simple extension that downloads an image and then converts it to grey scale using `sharp` node.js lib via
 * Phoenix Code node.js Extension. Extension can be activated using menu: `file->Download Image & Greyscale`.
 * */

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
        NodeConnector = brackets.getModule("NodeConnector");

    let nodeConnector;

    async function fetchImage() {
        const imageUrl = "https://picsum.photos/536/354";
        const response = await fetch(imageUrl);

        if (!response.ok) {
            throw new Error(
                `Failed to fetch image (status ${response.status})`
            );
        }

        return response.arrayBuffer();
    }

    // Function to run when the menu item is clicked
    async function handleHelloWorld() {
        if (!Phoenix.isNativeApp) {
            alert("Node Features only works in desktop apps.");
            return;
        }
        let html = "<b>Image conversion failed</b>";
        try {
            alert("downloading image...");
            // Fetch the image and get its array buffer
            const imageArrayBuffer = await fetchImage();

            // Call the nodeConnector to convert the image to grayscale
            const { buffer, success } = await nodeConnector.execPeer(
                "convertToGreyScale",
                { imageName: "imageName" },
                imageArrayBuffer
            );

            if (!success) {
                alert("Image conversion failed in Node.");
                return;
            }

            // Construct HTML with the grayscale image array buffer
            // For example, you can use the buffer as a base64 data URL
            html = `<img src="data:image/jpeg;base64,${Buffer.from(buffer).toString("base64")}">`;
        } catch (error) {
            console.error("Error:", error);
        }
        Dialogs.showModalDialog(DefaultDialogs.DIALOG_ID_INFO, "Image to greyscale with node.js", html);
    }

    // First, register a command - a UI-less object associating an id to a handler
    var MY_COMMAND_ID = "helloworld.imageConvert"; // package-style naming to avoid collisions
    CommandManager.register("Download Image & Greyscale", MY_COMMAND_ID, handleHelloWorld);

    // Then create a menu item bound to the command
    // The label of the menu item is the name we gave the command (see above)
    var menu = Menus.getMenu(Menus.AppMenuBar.FILE_MENU);
    menu.addMenuItem(MY_COMMAND_ID);

    // We could also add a key binding at the same time:
    //menu.addMenuItem(MY_COMMAND_ID, "Ctrl-Alt-W");
    // (Note: "Ctrl" is automatically mapped to "Cmd" on Mac)

    // Initialize extension once shell is finished initializing.
    AppInit.appReady(function () {
        // nb: Please enable `Debug menu> Phoenix code diagnostic tools> enable detailed logs` to view all console logs.`
        console.log("hello world");

        if (Phoenix.isNativeApp) {
            nodeConnector = NodeConnector.createNodeConnector(
                "your-extension-id-1",
                exports
            );
            // you can also execute nodejs code in dekstop builds
            // below code will execute the function `echoTest` defined in `node/index.js`
            nodeConnector.execPeer("echoTest", "yo!").then(console.log);
        }
    });
});
