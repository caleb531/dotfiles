// Your init script
//
// Atom will evaluate this file each time a new window is opened. It is run
// after packages are loaded/activated and after the previous editor state
// has been restored.
'use strict';

const {exec} = require('child_process');

// Set preferred size of current Atom window while preserving window position;
// assumes Tree View is open
function setPreferredWindowDimensions() {
  const originalWindowDimensions = atom.getWindowDimensions();
  atom.setWindowDimensions({
    width: 1080,
    height: 710,
    x: originalWindowDimensions.x,
    y: originalWindowDimensions.y
  });
}
setPreferredWindowDimensions();

// Sync Atom packages via package-sync package
function syncPackages() {
  const workspaceView = atom.views.getView(atom.workspace);
  return atom.commands.dispatch(workspaceView, 'package-sync:sync');
}
syncPackages();

// Extend the JavaScript tree-sitter grammar with additional highlighting
function extendJavaScriptTSGrammar() {
  // All Atom grammars are loaded asynchronously, so use setImmediate() to
  // ensure that the JS grammar is only modified when it has fully loaded
  setImmediate(() => {
    const jsGrammar = atom.grammars.treeSitterGrammarsById['source.js'];
    if (jsGrammar && jsGrammar.scopeMap) {
      // Colorize `this` and `arguments` in red like other language keywords
      jsGrammar.scopeMap.namedScopeTable.this = {result: 'variable.language.js'};
      jsGrammar.scopeMap.namedScopeTable.identifier.result.unshift({
        match: /^arguments$/,
        scopes: 'variable.language.js'
      });
      // Colorize JSON built-in object
      jsGrammar.scopeMap.namedScopeTable.identifier.result.unshift({
        match: /^JSON$/,
        scopes: 'meta.class'
      });
    }
  });
}
extendJavaScriptTSGrammar();

// Override getGrammars to work around bug with tree-sitter grammars never
// applying; see
// <https://github.com/atom/atom/issues/17029#issuecomment-457084440>
atom.grammars.getGrammars = () => {
  const allGrammars = atom.grammars.textmateRegistry.getGrammars();
  const tsGrammars = Object.values(atom.grammars.treeSitterGrammarsById);
  const combinedGrammars = tsGrammars.concat(allGrammars);
  const combinedGrammarNames = combinedGrammars.map((grammar) => grammar.name);
  return combinedGrammars.filter((grammar, g) => {
    return (
      // Prefer tree-sitter grammars whenever possible
      grammar.constructor.name === 'TreeSitterGrammar'
      // OR, if this is a first-mate grammar without a corresponding tree-sitter
      // grammar, add it to the list
      || combinedGrammarNames.indexOf(grammar.name) === g
    );
  });
};

// Add command to copy to clipboard an array of the editor's current cursor
// scopes
atom.commands.add('atom-text-editor:not([mini])', 'editor:copy-cursor-scope', () => {
  const editor = atom.workspace.getActiveTextEditor();
  const scopes = editor.getCursorScope().scopes;
  if (scopes) {
    const scopeString = JSON.stringify(scopes)
      .replace(/,/g, ', ')
      .replace(/"/g, '\'');
    atom.clipboard.write(scopeString);
    const list = scopes.map((item) => `* ${item}`);
    const content = `Copied Scopes at Cursor\n${list.join('\n')}`;
    atom.notifications.addInfo(content, {
      dismissable: true
    });
  } else {
    atom.notifications.addError('Scopes at Cursor', {
      detail: 'Could not write scopes to clipboard'
    });
  }
});

// Add command for revealing the project folder at the workspace level
atom.commands.add('atom-workspace', 'application:show-project-folder-in-file-manager', () => {
  const projectPaths = atom.project.getPaths();
  if (projectPaths.length > 0) {
    exec(`open ${projectPaths[0]}`);
  }
});
