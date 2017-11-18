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

setPreferredWindowDimensions()
syncPackages()
