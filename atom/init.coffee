# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.

fs = require('fs')
path = require('path')
{exec} = require('child_process')

# Sync Atom packages via package-sync package
syncPackages = ->
  workspaceView = atom.views.getView(atom.workspace)
  atom.commands.dispatch(workspaceView, 'package-sync:sync')

atom.commands.add('atom-workspace', 'application:show-current-project-folder-in-file-manager', ->
  paths = atom.project.getPaths()
  if paths.length != 0
    exec("open #{paths[0]}")
)

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

setPreferredWindowDimensions()
syncPackages()
