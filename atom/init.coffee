# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.

fs = require('fs')
path = require('path')
BufferedProcess = require('atom').BufferedProcess

# Path to the binary for Atom's package manager, apm
APM_PATH = atom.packages.getApmPath()
# Path to the directory where Atom stores user-installed packages
LOCAL_PKG_DIR_PATH = atom.packages.getPackageDirPaths()[0]
# Path to the remote package list used for comparison when syncing
REMOTE_PKG_LIST_PATH = fs.readlinkSync(
  path.join(atom.getConfigDirPath(), 'packages.txt'))
# Limit the rate of sync pushes to one second
PKG_SYNC_DELAY = 1000
# The name used for Python virtualenv directories
VIRTUAL_ENV_NAME = '.virtualenv'

# Activates Python virtualenv for this project directory if it exists
activateVirtualenv = ->
  project = atom.project.getPaths()[0]
  if project
    virtualenv = path.join(project, VIRTUAL_ENV_NAME)
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
  pkgList = fs.readdirSync(LOCAL_PKG_DIR_PATH)
  return pkgList.filter((pkg) -> pkg.indexOf('.') is -1)


# Retrueves the list of all synced packages
getRemotePkgList = ->
    pkgList = fs.readFileSync(REMOTE_PKG_LIST_PATH, 'utf8')
      .trimRight().split('\n')
    return pkgList


# Deactivates the given list of packages
deactivatePkgs = (pkgs) ->
  console.log('Deactivating packages: ' + pkgs.join(', '))
  pkgs.forEach((pkg) -> atom.packages.deactivatePackage(pkg))


# Uninstalls the given list of packages
uninstallPkgs = (pkgs, callback) ->
  if pkgs.length isnt 0
    pkgsStr = pkgs.join(', ')
    atom.notifications.addInfo('Uninstalling packages', {
        detail: pkgsStr
    })
    deactivatePkgs(pkgs)
    process = new BufferedProcess({
      command: APM_PATH,
      args: ['uninstall'].concat(pkgs),
      stderr: (data) -> console.log(String(data)),
      exit: (code) ->
        atom.notifications.addSuccess('Finished uninstalling packages', {
            detail: pkgsStr
        })
        callback?()
    })
  else
    callback?()


# Activates the given list of packages
activatePkgs = (pkgs) ->
  console.log('Activating packages: ' + pkgs.join(', '))
  pkgs.forEach((pkg) -> atom.packages.activatePackage(pkg))


# Installs the given list of packages
installPkgs = (pkgs, callback) ->
  if pkgs.length isnt 0
    pkgsStr = pkgs.join(', ')
    atom.notifications.addInfo('Installing packages', {
        detail: pkgsStr
    })
    process = new BufferedProcess({
      command: APM_PATH,
      args: ['install'].concat(pkgs),
      stderr: (data) -> console.log(String(data)),
      exit: (code) ->
        activatePkgs(pkgs)
        atom.notifications.addSuccess('Finished installing and activating packages', {
            detail: pkgsStr
        })
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
    # Uninstall local packages that are missing on remote
    removedPkgs = getArrayDiff(localPkgList, remotePkgList)
    uninstallPkgs(removedPkgs, ->
      # Install remote packages that are missing on local
      addedPkgs = getArrayDiff(remotePkgList, localPkgList)
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
    fs.writeFileSync(REMOTE_PKG_LIST_PATH, localPkgList.join('\n') + '\n')
    atom.notifications.addSuccess('Pushed package list to remote')
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
# Pull package list from remote; install missing packages and uninstall
# extraneous packages
pullPkgList(-> initializePackageSync())
