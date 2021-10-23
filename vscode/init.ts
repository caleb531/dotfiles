// @ts-ignore: ignore vscode module import
import { window, workspace, extensions, Extension, ExtensionContext, Uri } from 'vscode';
// @ts-ignore: ignore Path module import
import * as path from 'path';
// @ts-ignore: ignore Buffer module import
import { Buffer } from 'buffer';

// The designated path of the file where the list of installed user extensions
// should be kept
const EXTENSIONS_DUMP_PATH = Uri.parse(path.join('Users', 'Caleb', 'dotfiles', 'vscode', 'extensions.txt'));
const EXTENSIONS_DIR_PATH = Uri.parse(path.join('Users', 'Caleb', '.vscode', 'extensions'));

// Return a line-by-line string of extension IDs from the given extensions list
async function getExtensionIds() {
	// List all files/directories within ~/.vscode/extensions
	const fileList = await workspace.fs.readDirectory(EXTENSIONS_DIR_PATH);
	return fileList
		// Filter to only those entries named as {extension ID}-{version}
		.filter(([fileName, fileType]: [string, number]) => {
			return /^(\w[\w\.]+)/.test(fileName);
		})
		// Return only the extension ID for each entry (i.e. strip the version)
		.map(([fileName, fileType]: [string, number]) => {
			return fileName.replace(/(.*?)-(\d+(\.\d+)+)/, '$1');
		});
}

// Export the given list of extensions to the designated file
async function exportExtensionList() {
	return workspace.fs.writeFile(
		EXTENSIONS_DUMP_PATH,
		Buffer.from((await getExtensionIds()).join('\n'))
	);
}

// Filter the given extensions list to only those installed by the user (i.e.
// exclude any extension that is bundled with VS Code)
function getUserExtensions(extensionList: Array<Extension>) {
	return extensionList.filter((extension) => {
		// All bundled extensions are assumed to be under /Applications/;
		// exclude those
		return !extension.extensionPath.startsWith('/Applications/');
	});
}

// Export newly-installed extensions to the designated file
async function exportNewExtensions() {
    let currentExtensionCount = extensions.all.length;
    // Detect when an extension is installed, uninstalled, enabled, or disabled
    extensions.onDidChange(async function () {
		const newExtensions = await getExtensionIds();
        if (newExtensions.length > currentExtensionCount) {
			exportExtensionList().then(() => {
	            window.showInformationMessage('Installed extension has been exported');
			});
        } else if (newExtensions.length < currentExtensionCount) {
			exportExtensionList().then(() => {
            	window.showInformationMessage('Uninstalled extension has been exported');
			});
		} else {
            window.showInformationMessage('Extension updated');
        }
        currentExtensionCount = newExtensions.length;
    });
}

export async function init(context: ExtensionContext) {
    window.showInformationMessage('Welcome! Love, Your Init Script');
    await exportNewExtensions();
}
