#!/usr/bin/env bash

echo "Configuring all..."

source ./config/create_symlinks.sh
source ./config/set_prefs.sh
source ./config/install_packages.sh
source ./config/install_casks.sh
source ./personal/config/config_all.sh
