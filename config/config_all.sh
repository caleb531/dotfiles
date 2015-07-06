#!/bin/bash

echo "Configuring all..."

source ./config/create-symlinks.sh
source ./config/set-prefs.sh
source ./config/install-packages.sh
source ./config/install-casks.sh
