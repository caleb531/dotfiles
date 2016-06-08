#!/usr/bin/env bash

echo "Configuring all..."

./config/create_symlinks.sh
./config/set_prefs.sh
./config/install_packages.sh
./config/install_casks.sh
./personal/config/config_all.sh
