// @ts-ignore: ignore vscode module import
import { window, workspace, extensions, Extension, ExtensionContext, Uri } from 'vscode';
// @ts-ignore: ignore Path module import
import * as path from 'path';
// @ts-ignore: ignore Buffer module import
import { Buffer } from 'buffer';

// The designated path of the file where the list of installed user extensions
// should be kept
const EXTENSIONS_LIST_PATH = path.join('Users', 'Caleb', 'dotfiles', 'vscode', 'extensions.txt');

// Return a line-by-line string of extension IDs from the given extensions list
function getExtensionIds(extensionList: Array<Extension>) {
	return extensionList.map((extension) => {
		return extension.id;
	}).join('\n');
}

// Export the given list of extensions to the designated file
function exportExtensionList(extensionList: Array<Extension>) {
	extensionList.forEach((extension: any) => {
		window.showInformationMessage('hey');
	});
	workspace.fs.writeFile(
		Uri.parse(EXTENSIONS_LIST_PATH),
		Buffer.from(getExtensionIds(extensionList))
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
function exportNewExtensions() {
    let currentExtensionCount = extensions.all.length;
    // Detect when an extension is installed, uninstalled, enabled, or disabled
    extensions.onDidChange(() => {
		const newExtensionsCount = extensions.all.length;
        if (newExtensionsCount > currentExtensionCount) {
            window.showInformationMessage('Installed or enabled extension');
			exportExtensionList(getUserExtensions(extensions.all));
        } else if (newExtensionsCount < currentExtensionCount) {
            window.showInformationMessage('Uninstalled or disabled extension');
			exportExtensionList(getUserExtensions(extensions.all));
		} else {
            window.showInformationMessage('Extension updated');
        }
        currentExtensionCount = newExtensionsCount;
    });
}

export function init(context: ExtensionContext) {
    // window.showInformationMessage('Welcome! Love, Your Init Script');
    exportNewExtensions();
}
