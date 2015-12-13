#!/bin/bash

echo "Exporting configuration..."

echo "Updating Atom package list..."
apm ls --installed --bare | grep -Eo '^[A-Za-z0-9\-]+' > ./atom/packages.txt
