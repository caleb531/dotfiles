# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.

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

setPreferredWindowDimensions()
syncPackages()
