#!/bin/bash

echo "Exporting configuration..."

echo "Updating Atom package list..."
apm ls --installed --bare | grep -oP '[a-z\-]+' > ./atom/packages.txt
