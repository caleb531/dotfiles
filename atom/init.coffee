# Your init script

fs = require('fs')
path = require('path')
BufferedProcess = require('atom').BufferedProcess

# Path to the binary for Atom's package manager, apm
APM_PATH = atom.packages.getApmPath()
# Path to the directory where Atom stores user-installed packages
LOCAL_PKG_DIR_PATH = atom.packages.getPackageDirPaths()[0]
# Path to the remote package list used for comparison when syncing
REMOTE_PKG_LIST_PATH = fs.readlinkSync(
  path.join(atom.configDirPath, 'packages.txt'))
# Limit the rate of sync pushes to one second
PKG_SYNC_DELAY = 1000
# The name used for Python virtualenv directories
VIRTUAL_ENV_NAME = '.virtualenv'

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


# Returns elements in the first array that aren't in the second
getArrayDiff = (first, second) ->
  return first.filter((elem) -> second.indexOf(elem) is -1)


# Retrieves the list of all user-installed local packages
getLocalPkgList = ->
  pkgList = fs.readdirSync LOCAL_PKG_DIR_PATH
  return pkgList.filter (pkg) -> pkg.indexOf('.') is -1


# Retrueves the list of all synced packages
getRemotePkgList = ->
    pkgList = fs.readFileSync(REMOTE_PKG_LIST_PATH, 'utf8')
      .trimRight().split('\n')
    return pkgList


# Uninstalls the given list of packages
uninstallPkgs = (pkgs, callback) ->
  if pkgs.length isnt 0
    console.log('Uninstalling packages: ' + pkgs.join(', '))
    process = new BufferedProcess({
      command: APM_PATH,
      args: ['uninstall'].concat(pkgs),
      stderr: (data) -> console.log(String(data)),
      exit: (code) -> callback?()
    })
  else
    callback?()


# Activates the given list of installed packages
activatePkgs = (pkgs) ->
  console.log('Activating packages: ' + pkgs.join(', '))
  pkgs.forEach((pkg) -> atom.packages.activatePackage(pkg))


# Installs the given list of packages
installPkgs = (pkgs, callback) ->
  if pkgs.length isnt 0
    console.log('Installing packages: ' + pkgs.join(', '))
    process = new BufferedProcess({
      command: APM_PATH,
      args: ['install'].concat(pkgs),
      stderr: (data) -> console.log(String(data)),
      exit: (code) ->
        activatePkgs(pkgs)
        callback?()
    })
  else
    callback?()


# Brings local package list into sync with remote package list
pullPkgList = (callback) ->
  localPkgList = getLocalPkgList()
  remotePkgList = getRemotePkgList()
  # Only push if local package list differs from remote package list
  if localPkgList.join(',') isnt remotePkgList.join(',')
    console.log('Pulling package list from remote...')
    removedPkgs = getArrayDiff(localPkgList, remotePkgList)
    addedPkgs = getArrayDiff(remotePkgList, localPkgList)
    # Uninstall local packages that are missing on remote
    uninstallPkgs(removedPkgs, ->
      # Install remote packages that are missing on local
      installPkgs(addedPkgs, -> callback?())
    )
  else
    console.log('No changes to pull')
    callback?()


# Pushes local package list to remote
pushPkgList = ->
  localPkgList = getLocalPkgList()
  remotePkgList = getRemotePkgList()
  # Only push if local package list differs from remote package list
  if localPkgList.join(',') isnt remotePkgList.join(',')
    console.log('Pushing local package list to remote...')
    fs.writeFile(REMOTE_PKG_LIST_PATH, localPkgList.join('\n') + '\n')
  else
    console.log('No changes to push')


# Initializes package sync within Atom
initializePackageSync = ->
  console.log('Watching for package activate/deactivate...')
  timeout = null
  # Push package list when packages are activated or deactivated
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

pullPkgList(-> initializePackageSync())
