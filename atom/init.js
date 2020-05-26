// Your init script
//
// Atom will evaluate this file each time a new window is opened. It is run
// after packages are loaded/activated and after the previous editor state
// has been restored.
'use strict';

const {exec} = require('child_process');
const path = require('path');
const util = require('util');


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
function extendJavaScriptTreeSitterGrammar(scopeName) {
  const jsGrammar = atom.grammars.treeSitterGrammarsById[scopeName];
  if (jsGrammar && jsGrammar.scopeMap) {
    // Colorize `this` and `arguments` in red like other language keywords
    jsGrammar.scopeMap.addSelector('this', 'variable.language.js');
    jsGrammar.scopeMap.addSelector('identifier', [
      {
        match: /^arguments$/,
        scopes: 'variable.language.js'
      },
      // Colorize JSON built-in object like other class names (instead of like an
      // object)
      {
        match: /^JSON$/,
        scopes: 'meta.class'
      },
      // Preserve existing identifier grammar rules
      ...jsGrammar.scopeMap.namedScopeTable.identifier.result
    ]);
    // Colorize `new a.b` syntax (when constructor is a property of an object)
    jsGrammar.scopeMap.addSelector('new_expression > member_expression', 'meta.class');
    // Colorize formal function parameters in TypeScript code
    jsGrammar.scopeMap.addSelector('formal_parameters > required_parameter > identifier', 'variable.parameter.function');
  }
}
// All Atom grammars are loaded asynchronously, so use nested setImmediate()
// calls to wait for the first-mate JavaScript grammar to load before modifying
// the tree-sitter grammar
setImmediate(() => {
  setImmediate(() => {
    extendJavaScriptTreeSitterGrammar('source.js');
    extendJavaScriptTreeSitterGrammar('source.ts');
  });
});


// Extend the Python tree-sitter grammar with additional highlighting
function extendPythonTreeSitterGrammar() {
  // Force tree-sitter grammar to override first-mate grammar
  const pyGrammar = atom.grammars.treeSitterGrammarsById['source.python'];
  if (pyGrammar && pyGrammar.scopeMap) {
    // Colorize variable and class names within class argument lists
    pyGrammar.scopeMap.addSelector(
      'class_definition > argument_list > attribute',
      'entity.other.inherited-class.python'
    );
    pyGrammar.scopeMap.addSelector(
      'class_definition > argument_list > identifier',
      'entity.other.inherited-class.python'
    );
    // Colorize variable and class names as values of keyword arguments within
    // class argument lists
    pyGrammar.scopeMap.addSelector(
      'class_definition > argument_list > keyword_argument > attribute',
      'entity.other.inherited-class.python'
    );
    pyGrammar.scopeMap.addSelector(
      'class_definition > argument_list > keyword_argument > identifier:nth-child(2)',
      'entity.other.inherited-class.python'
    );
    // Colorize `self` and `cls`
    pyGrammar.scopeMap.addSelector('identifier, identifier:nth-child(0)', [
      {
        match: /^self$/,
        scopes: 'variable.language.self.python'
      },
      {
        match: /^cls$/,
        scopes: 'variable.language.cls.python'
      }
    ]);
    // Colorize format specifiers for f-strings
    pyGrammar.scopeMap.addSelector(
      'string > interpolation > format_specifier',
      'meta.format-specifier'
    );
  }
}
// Wait for the Python first-mate grammar to load before modifying the
// tree-sitter grammar
setImmediate(() => {
  setImmediate(() => {
    extendPythonTreeSitterGrammar();
  });
});


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


function findGitDir(path) {

}


// Add command for copying commit hash of current line
atom.commands.add('atom-text-editor:not([mini])', 'editor:copy-blame-commit-hash-for-current-line', () => {
  // const editor = atom.workspace.getActiveTextEditor();
  // const absFilePath = editor.getPath();
  // const execPromise = util.promisify(exec);
  // const relFilePath = path.relative(repoPath, editor.getPath());
  // // console.log(relFilePath);
  // // exec(`git blame ${}`, (err, stdout) => {
  // //   console.log(stdout);
  // // });
});


// Add command for revealing the project folder at the workspace level
atom.commands.add('atom-workspace', 'application:show-project-folder-in-file-manager', () => {
  const projectPaths = atom.project.getPaths();
  if (projectPaths.length > 0) {
    exec(`open ${projectPaths[0]}`);
  }
});
