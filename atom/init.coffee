# Your init script

fs = require 'fs'
path = require 'path'
DEFAULT_WORKON_HOME = path.join(process.env.HOME, '.virtualenvs')


# Get path to directory containing all Python virtualenvs
getVirtualenvHome = ->

  if process.env.WORKON_HOME
    return process.env.WORKON_HOME
  else
    return DEFAULT_WORKON_HOME


# Activate Python virtualenv for this project directory if it exists
activateVirtualenv = ->

  project = atom.project.getPaths()[0]
  if project
    virtualenv = path.join(getVirtualenvHome(), path.basename(project))
    # Do not activate virtualenv if project is itself a virtualenv
    if virtualenv isnt project
      fs.lstat(virtualenv, (err, stats) ->
        if not err and stats.isDirectory()
          process.env.PATH = [virtualenv, process.env.PATH].join ':'
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
