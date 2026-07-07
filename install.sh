#!/bin/sh

echo "Setting up your Mac..."

# Set DOTFILES path
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# Check for Oh My Zsh and install if we don't have it
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew bundle --file "$DOTFILES/Brewfile"

# Make ZSH the default shell environment
chsh -s $(which zsh)

# Sets brew completions
if command -v brew &> /dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Loading
if [ -f "$HOME/.zshrc" ]; then
  mv $HOME/.zshrc $HOME/.zshrc.bk
fi
echo "source $DOTFILES/.zshrc" > $HOME/.zshrc
source $HOME/.zshrc

# Copy the Mackup config file to the home directory
cp "$DOTFILES/.mackup.cfg" $HOME/.mackup.cfg

# Set macOS preferences
source "$DOTFILES/.macos"
