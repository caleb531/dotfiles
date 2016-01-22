#!/bin/bash

echo "Exporting configuration..."

echo "Updating Atom package list..."
apm ls --installed --bare > ./atom/packages.txt
