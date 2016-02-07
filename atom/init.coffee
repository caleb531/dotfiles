# Your init script

fs = require 'fs'
path = require 'path'
VIRTUAL_ENV_NAME = '.virtualenv'

LOCAL_PKG_DIR_PATH = atom.packages.getPackageDirPaths()[0]
REMOTE_PKG_LIST_PATH = fs.readlinkSync(
  path.join(path.dirname(LOCAL_PKG_DIR_PATH), 'packages.txt'))
PKG_SYNC_DELAY = 1000

# Activates Python virtualenv for this project directory if it exists
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
          console.log("Activated virtualenv at #{virtualenv}")
      )


# Retrieves the list of all user-installed local packages
getLocalPkgList = ->
  pkgList = fs.readdirSync LOCAL_PKG_DIR_PATH
  return pkgList.filter (pkg) -> (pkg.indexOf('.') == -1)


# Retrueves the list of all synced packages
getRemotePkgList = ->
    pkgList = fs.readFileSync(REMOTE_PKG_LIST_PATH, {
      encoding: 'utf8'
    }).trimRight().split('\n')
    return pkgList


# Pushes local package list to remote when packages are installed/uninstalled
pushPkgList = ->
  localPkgList = getLocalPkgList()
  remotePkgList = getRemotePkgList()
  if localPkgList.join(',') isnt remotePkgList.join(',')
    console.log('Pushing local package list to remote...')
    fs.writeFile(REMOTE_PKG_LIST_PATH, localPkgList.join('\n') + '\n')
  else
    console.log('Already up-to-date')

# Initializes package sync within Atom
initializePackageSync = ->
  timeout = null
  atom.packages.onDidActivatePackage (pkg) ->
    clearTimeout(timeout)
    timeout = setTimeout(pushPkgList, PKG_SYNC_DELAY)
  atom.packages.onDidDeactivatePackage (pkg) ->
    clearTimeout(timeout)
    timeout = setTimeout(pushPkgList, PKG_SYNC_DELAY)


# Explicitly define PATH and detect project virtualenvs
process.env.PATH = '/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
activateVirtualenv()
# Ensure that Python correctly outputs Unicode characters
process.env.PYTHONIOENCODING = 'utf_8'
# Prevent Python from generating bytecode (.pyc, .pyo) files
process.env.PYTHONDONTWRITEBYTECODE = '1'
initializePackageSync()
