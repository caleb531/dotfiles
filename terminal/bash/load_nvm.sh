export NVM_DIR="$HOME/.nvm"
if [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ]; then
	source "$BREW_PREFIX/opt/nvm/nvm.sh"
fi
if [ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]; then
	source "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi
