# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.

fs = require('fs')
path = require('path')

# Activates Python virtualenv for this project directory if it exists
activateVirtualenv = ->
  project = atom.project.getPaths()[0]
  if project
    virtualenv = path.join(project, process.env.VIRTUAL_ENV_NAME)
    fs.lstat(virtualenv, (err, stats) ->
      if not err and stats.isDirectory()
        virtualenv_bin = path.join(virtualenv, 'bin')
        process.env.PATH = [virtualenv_bin, process.env.PATH].join ':'
        process.env.VIRTUAL_ENV = virtualenv
        console.log("Activated virtualenv at #{virtualenv}")
    )

# Sync Atom packages via package-sync package
syncPackages = ->
  workspaceView = atom.views.getView(atom.workspace)
  atom.commands.dispatch(workspaceView, 'package-sync:sync')

# Set preferred size of current Atom window while preserving window position;
# assumes Tree View is open
setPreferredWindowDimensions = ->
  originalWindowDimensions = atom.getWindowDimensions()
  atom.setWindowDimensions({
    width: 1060,
    height: 710,
    x: originalWindowDimensions.x,
    y: originalWindowDimensions.y
  })

setPreferredWindowDimensions()
# Explicitly define PATH and detect project virtualenvs
process.env.PATH = '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
if process.env.VIRTUAL_ENV_NAME
  activateVirtualenv()
syncPackages()
