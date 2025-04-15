/**
 * This is an optional node extension that is available only in desktop builds. This code will be run in node. You can
 * bring in any third party node modules using package.json in folder `node/package.json`
 *
 * nb: Please note that you should not package `node_modules` folder when you care creating the extension zip file.
 * Zip `node/package-lock.json`, but not node modules.
 *
 * To communicate between this node file and the phoenix extension use: NodeConnector-API -
 * See. https://docs.phcode.dev/api/API-Reference/NodeConnector for detailed docs.
 **/
console.log("hello world node extension");

const sharp = require("sharp");

const extnNodeConnector = global.createNodeConnector(
    "your-extension-id-1",
    exports
);

async function echoTest(name) {
    return "hello from node " + name;
}

async function convertToGreyScale(imageName, imageArrayBuffer) {
    try {
        // Convert the image buffer to grayscale using sharp
        const outputBuffer = await sharp(imageArrayBuffer)
            .grayscale() // Convert to grayscale
            .toBuffer(); // Convert to buffer

        // Return the output buffer
        return {
            success: true,
            buffer: outputBuffer // a single binary array buffer can be transmitted, it should use key buffer
        };
    } catch (error) {
        throw new Error("Error converting image to black and white:", error);
    }
}

exports.echoTest = echoTest;
exports.convertToGreyScale = convertToGreyScale;
