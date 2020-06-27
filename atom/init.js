// Your init script
//
// Atom will evaluate this file each time a new window is opened. It is run
// after packages are loaded/activated and after the previous editor state
// has been restored.
'use strict';

const {execSync} = require('child_process');
const fs = require('fs');
const path = require('path');


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
    // Colorize function declaration names in TypeScript code
    jsGrammar.scopeMap.addSelector('function_declaration > identifier', 'entity.name.function');
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
      detail: 'Could not write scopes to clipboard',
      dismissable: true
    });
  }
});


// Add command for copying commit hash of current line
atom.commands.add('atom-text-editor:not([mini])', 'editor:copy-blame-commit-for-current-line', () => {
  try {
    const editor = atom.workspace.getActiveTextEditor();
    const currentFilePath = editor.getPath().trim();
    const currentLine = editor.getSelectedBufferRange().start.row + 1;
    const gitRepoPath = String(execSync('git rev-parse --show-toplevel', {
      cwd: path.dirname(currentFilePath)
    })).trim();
    const relFilePath = path.relative(gitRepoPath, currentFilePath);
    // The existence check is to ensure that currentFilePath is a valid directory
    // path, so that this code isn't susceptible to an injection attack
    if (!fs.existsSync(currentFilePath)) {
      throw new TypeError('Current file path does not exist');
    }
    const blameLines = String(execSync(`git blame ${relFilePath}`, {
      cwd: gitRepoPath
    })).split('\n');
    const currentBlameLine = blameLines[currentLine - 1];
    if (!(currentBlameLine && currentBlameLine.trim())) {
      throw new TypeError('This line has not been committed yet');
    }
    const commitId = currentBlameLine.match(/^[0-9a-f]+/)[0];
    if (!commitId || commitId === '00000000') {
      throw new TypeError('This line has not been committed yet');
    }
    atom.clipboard.write(currentBlameLine.match(/^[0-9a-f]+/)[0]);
    atom.notifications.addInfo('Commit copied to clipboard!', {
      detail: commitId,
      dismissable: true
    });
  } catch (error) {
    atom.notifications.addError('Error copying blame commit!', {
      detail: error.message,
      dismissable: true
    });
  }
});


// Add command for revealing the project folder at the workspace level
atom.commands.add('atom-workspace', 'application:show-project-folder-in-file-manager', () => {
  const projectPaths = atom.project.getPaths();
  if (projectPaths.length > 0) {
    execSync(`open ${projectPaths[0]}`);
  }
});
