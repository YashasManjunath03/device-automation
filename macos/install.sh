#!/bin/bash

#################
### Initial setup
#################

# Ask for sudo upfront.
echo "Some operations need sudo privileges. Please enter your password."
sudo -v
# Ask user for required information.
read -p "Enter your work company name: " company_name
# Define needed variables.
git_user_name=YashasManjunath03
git_automation_repo_name=device-automation
git_user_dir=~/dev/$git_user_name
git_company_dir=~/dev/$company_name
git_dracula_dir=~/dev/dracula
automation_repo_git_url=https://github.com/$git_user_name/$git_automation_repo_name.git
# Create the directory to store git repos.
mkdir -p $git_user_dir
mkdir -p $git_company_dir
mkdir -p $git_dracula_dir

###################################
### Apply operating system settings
###################################

echo "Setting up operating system settings..."
defaults write .GlobalPreferences com.apple.mouse.scaling -1
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write com.apple.dock tilesize -integer 20
killall Dock
echo "Done."

###########################
### Install package manager
###########################

echo "Installing brew..."
xcode-select --install
which -s brew
if [[ $? != 0 ]]; then
    yes '' | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$USER/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    brew update
fi
echo "Done."

##############################
### Install blocking packages.
##############################

echo "Installing blocking packages please stay here and enter credentials as needed..."
brew install --cask dotnet-sdk
brew install --cask microsoft-teams
brew install --cask microsoft-word
softwareupdate --install-rosetta
echo "Done. You can now go and let the script install the rest."

################
### Install git.
################

echo "Installing git..."
brew install git
echo "Done."

#############################
### Clone the automation repo
#############################

cd $git_user_dir && git clone $automation_repo_git_url

###############
### Install ZSH
###############

echo "Installing Zsh and Oh My Zsh..."
# Zsh
if ! brew list zsh &>/dev/null; then
    # Install Zsh.
    brew install zsh
    # Install Oh My Zsh.
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    # Install the dracula theme.
    cd $git_dracula_dir && git clone https://github.com/dracula/zsh.git
    ln -s $git_dracula_dir/zsh/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
    # Activate the dracula theme.
    sed -i '' 's/robbyrussell/dracula/g' ~/.zshrc
    echo 'export DRACULA_DISPLAY_NEW_LINE=1' >>~/.zshrc
fi
echo "Done."

###############
### Set aliases
###############

echo 'alias gfc="git fetch && git checkout"' >>~/.zshrc
echo 'alias startdev="podman machine start && podman start storage-dev redis-dev mssql-dev"' >>~/.zshrc
echo 'alias stopdev="podman stop storage-dev redis-dev mssql-dev && podman machine stop"' >>~/.zshrc
echo 'alias update_all="./dev/'"$git_user_name"'/'"$git_automation_repo_name"'/macos/update.sh"' >>~/.zshrc

###########
### Browser
###########

echo "Installing browsers..."
brew install --cask firefox
brew install --cask google-chrome
echo "Done."

###########
### Utility
###########

echo "Installing utility packages..."
brew tap homebrew/cask-drivers
brew install logitech-options
brew install --cask iterm2
# Download the dracula theme for iterm2.
cd $git_dracula_dir && git clone https://github.com/dracula/iterm.git
echo "Done."

###############
### Development
###############

echo "Installing development packages..."
# CLI
brew install --cask powershell
brew install nvm
# Add nvm path to shells.
echo "export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"" >>~/.zshrc
# Reload shells.
source ~/.zshrc
# Install latest LTS version of node.
nvm install --lts
brew install yarn
brew install podman
brew install azure-cli
brew install nuget
brew tap azure/bicep
brew install bicep
brew install rbenv ruby-build
brew install cocoapods

# SDK
dotnet tool install --global dotnet-ef

# IDE / Editor
brew install --cask visual-studio-code
brew install --cask rider

# Tools
brew install --cask microsoft-azure-storage-explorer
brew install --cask postman
brew install --cask azure-data-studio
brew install --cask redisinsight
brew install --cask podman-desktop
echo "Done."

#################
### Communication
#################

echo "Installing communication packages..."
brew install --cask discord
echo "Done."

#########
### Media
#########

echo "Installing media packages..."
brew install --cask spotify
brew install --cask vlc
echo "Done."

################
### Office Tools
################

echo "Installing office tools..."
brew install --cask microsoft-excel
brew install --cask microsoft-powerpoint
brew install --cask onedrive
echo "Done."

###########
# App Store
###########

read -p "Sign in to App Store and press ENTER to continue..."

echo "Installing App Store packages..."
# Install command line tool for app store
brew install mas

# Install XCode from app store.
mas install 497799835
# Install ColorSlurp from app store.
mas install 1287239339
# Install Outlook from app store.
mas install 985367838
echo "Done."