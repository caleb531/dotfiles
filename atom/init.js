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
function extendJavaScriptTreeSitterGrammar() {
  const jsGrammar = atom.grammars.treeSitterGrammarsById['source.js'];
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
  }
}
// All Atom grammars are loaded asynchronously, so use nested setImmediate()
// calls to wait for the first-mate JavaScript grammar to load before modifying
// the tree-sitter grammar
setImmediate(() => {
  setImmediate(() => {
    extendJavaScriptTreeSitterGrammar();
  });
});


// Extend the Python tree-sitter grammar with additional highlighting
function extendPythonTreeSitterGrammar() {
  // Force tree-sitter grammar to override first-mate grammar
  const pyGrammar = atom.grammars.treeSitterGrammarsById['source.python'];
  if (pyGrammar && pyGrammar.firstLineRegex) {
    pyGrammar.firstLineRegex = atom.grammars.textmateRegistry.grammarsByScopeName['source.python'].firstLineRegex;
  }
  if (pyGrammar && pyGrammar.scopeMap) {
    // Colorize function parameter names
    pyGrammar.scopeMap.addSelector(
      'parameters > identifier',
      'variable.parameter.function'
    );
    pyGrammar.scopeMap.addSelector(
      'default_parameter > identifier:nth-child(0)',
      'variable.parameter.function'
    );
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
  }
  // Re-apply Python tree-sitter grammar to all open Python files
  atom.grammars.grammarScoresByBuffer.forEach((score, buffer) => {
    if (buffer.getLanguageMode().grammar.scopeName === 'source.python' && !atom.grammars.languageOverridesByBufferId.has(buffer.id)) {
      atom.grammars.autoAssignLanguageMode(buffer);
    }
  });
}
// Wait for the Python first-mate grammar to load before modifying the
// tree-sitter grammar
setImmediate(() => {
  setImmediate(() => {
    extendPythonTreeSitterGrammar();
  });
});


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

// Change the base font size to 16 so that pressing cmd-0 will reset the font
// size to my preferred
atom.commands.add('body', 'window:reset-font-size', () => {
  atom.config.set('editor.fontSize', 16);
});
