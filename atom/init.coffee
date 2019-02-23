# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.

exec = require('child_process').exec
fs = require('fs')
path = require('path')

# Sync Atom packages via package-sync package
syncPackages = ->
  workspaceView = atom.views.getView(atom.workspace)
  atom.commands.dispatch(workspaceView, 'package-sync:sync')

# Set preferred size of current Atom window while preserving window position;
# assumes Tree View is open
setPreferredWindowDimensions = ->
  originalWindowDimensions = atom.getWindowDimensions()
  atom.setWindowDimensions({
    width: 1080,
    height: 710,
    x: originalWindowDimensions.x,
    y: originalWindowDimensions.y
  })

# Add command for revealing the project folder at the workspace level
atom.commands.add('atom-workspace', 'application:show-project-folder-in-file-manager', ->
  projectPaths = atom.project.getPaths()
  if projectPaths.length isnt 0
    exec("open #{projectPaths[0]}")
)

# Add command to copy to clipboard an array of the editor's current cursor
# scopes
atom.commands.add('atom-text-editor:not([mini])', 'editor:copy-cursor-scope', ->
  editor = atom.workspace.getActiveTextEditor()
  scopes = editor.getCursorScope()?.scopes
  if scopes
    scopeString = JSON.stringify(scopes)
      .replace(/,/g, ', ')
      .replace(/"/g, '\'')
    atom.clipboard.write(scopeString)
    list = scopes.map (item) -> "* #{item}"
    content = "Copied Scopes at Cursor\n#{list.join('\n')}"
    atom.notifications.addInfo(content, {
      dismissable: true
    })
  else
    atom.notifications.addError('Scopes at Cursor', {
      detail: "Could not write scopes to clipboard"
    })
)

setPreferredWindowDimensions()
syncPackages()
