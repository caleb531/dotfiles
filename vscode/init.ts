// @ts-ignore: ignore vscode module import
import { extensions, ExtensionContext } from 'vscode';
// @ts-ignore: ignore Path module import
import * as path from 'path';
// @ts-ignore: ignore child_process module import
import { exec } from 'child_process';

// Export full list of installed extensions
function exportExtensions(): void {
  exec(path.join('~', 'dotfiles', 'setup', 'export_vscode_extensions.sh'));
}


// Install synced extensions not already installed on this machine
function installLatestExtensions(): void {
  exec(path.join('~', 'dotfiles', 'setup', 'install_vscode_extensions.sh'));
}

export function init(context: ExtensionContext): void {
  // Detect when an extension is installed, uninstalled, enabled, or disabled
  extensions.onDidChange(() => exportExtensions());
  installLatestExtensions();
}
