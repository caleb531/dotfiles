# Your init script

fs = require 'fs'
path = require 'path'
VIRTUAL_ENV_NAME = '.virtualenv'

# Activate Python virtualenv for this project directory if it exists
activateVirtualenv = ->

  project = atom.project.getPaths()[0]
  if project
    virtualenv = path.join(project, VIRTUAL_ENV_NAME)
    # Do not activate virtualenv if project is itself a virtualenv
    if virtualenv isnt project
      fs.lstat(virtualenv, (err, stats) ->
        if not err and stats.isDirectory()
          virtualenv_bin = path.join(virtualenv, 'bin')
          process.env.PATH = [virtualenv_bin, process.env.PATH].join ':'
          process.env.VIRTUAL_ENV = virtualenv
          console.log "Activated virtualenv at #{virtualenv}"
      )


# Explicitly define PATH and detect project virtualenvs
process.env.PATH = '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
activateVirtualenv()
# Ensure that Python correctly outputs Unicode characters
process.env.PYTHONIOENCODING = 'utf_8'
# Prevent Python from generating bytecode (.pyc, .pyo) files
process.env.PYTHONDONTWRITEBYTECODE = '1'
