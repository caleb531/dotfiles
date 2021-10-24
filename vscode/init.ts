// @ts-ignore: ignore vscode module import
import { extensions, ExtensionContext } from 'vscode';
// @ts-ignore: ignore Path module import
import * as path from 'path';
// @ts-ignore: ignore child_process module import
import { exec } from 'child_process';

// The designated path of the shell script that exports all installed user
// extensions
const EXTENSIONS_EXPORT_SCRIPT_PATH = path.join(
  '~', 'dotfiles', 'setup', 'export_vscode_extensions.sh'
);
// The designated path of the shell script that installs all extensions not
// already installed on this machine
const EXTENSIONS_INSTALL_SCRIPT_PATH = path.join(
  '~', 'dotfiles', 'setup', 'install_vscode_extensions.sh'
);

// Export full list of installed extensions
function exportExtensions() {
  exec(EXTENSIONS_EXPORT_SCRIPT_PATH);
}


// Install synced extensions not already installed on this machine
function installLatestExtensions() {
  exec(EXTENSIONS_INSTALL_SCRIPT_PATH);
}

export function init(context: ExtensionContext) {
  // Detect when an extension is installed, uninstalled, enabled, or disabled
  extensions.onDidChange(() => exportExtensions());
  installLatestExtensions();
}
