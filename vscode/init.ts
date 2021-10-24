// @ts-ignore: ignore vscode module import
import { window, workspace, extensions, Extension, ExtensionContext, Uri } from 'vscode';
// @ts-ignore: ignore Path module import
import * as path from 'path';
// @ts-ignore: ignore Buffer module import
import { Buffer } from 'buffer';
// @ts-ignore: ignore child_process module import
import { exec } from 'child_process';

// The designated path of the shell script that exports all installed user
// extensions
const EXTENSIONS_EXPORT_SCRIPT_PATH = path.join(
  '~', 'dotfiles', 'setup', 'export_vscode_extensions.sh'
);

// Export newly-installed extensions to the designated file
function exportNewExtensions() {
  // Detect when an extension is installed, uninstalled, enabled, or disabled
  extensions.onDidChange(() => {
    exec(EXTENSIONS_EXPORT_SCRIPT_PATH);
  });
}

export function init(context: ExtensionContext) {
  // window.showInformationMessage('Welcome! Love, Your Init Script');
  exportNewExtensions();
}
