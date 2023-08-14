#! /usr/bin/bash

echo -e "\033[0;93m\n\nYou are Running a Script\nUse it at your own risk!\n\n\e[0m"
echo -e "#################################################################\n"
echo -e "You are about to install the applications you want to install\n"
echo -e "#################################################################\n\n\n"
echo -e "\033[0;92mThe script will ask for administrative access\n\e[0m"
echo You have 5 seconds to proceed ...
echo or
echo -e "hit Ctrl+C to quit\n"
sleep 6

###################################
# Detect the Linux distribution
###################################

## Same as cat /etc/os-release
if [ -f /etc/os-release ]; then
    source /etc/os-release
    DISTRO=$ID
else
    DISTRO=$(uname -s | tr '[:upper:]' '[:lower:]')
fi

## Set default package manager commands
case "$DISTRO" in
    ubuntu|debian|mint|lite|zorin)
        PKG_MANAGER="sudo apt-get"
        PKG_INSTALL="install -y"
        ;;
    centos|rhel)
        PKG_MANAGER="sudo yum"
        PKG_INSTALL="install"
        ;;
    fedora)
        PKG_MANAGER="sudo dnf"
        PKG_INSTALL="install"
        ;;
     opensuse-tumbleweed|opensuse-leap)
     	PKG_MANAGER="sudo zypper"
        PKG_INSTALL="install -y"
        ;;
     arch|endeavouros|manjaro)
     	PKG_MANAGER="sudo pacman"
        PKG_INSTALL="-S --noconfirm"
        ;;
    *)
        echo "Unsupported or unknown distribution: $DISTRO"
        exit 1
        ;;
esac

echo -e "\nDetected distribution: \033[0;92m$DISTRO\e[0m\n\n"

# Check if the package is installed
is_package_installed() {
    if rpm -q "$1" >/dev/null 2>&1; then
       return 0  # Package is installed
    else
	return 1 # Package is not installed
    fi
}

# Packages to install
PACKAGES_FILE="./packages/packages.list"
if [ ! -f "$PACKAGES_FILE" ]; then
    echo "Packages file $PACKAGES_FILE not found."
    exit 1
fi

PACKAGES=($(cat "$PACKAGES_FILE"))

## Execute the command to install apps with the native package manager
echo "Installing/Checking packages from the list"
echo $PKG_MANAGER $PKG_INSTALL ${PACKAGES[@]}
$PKG_MANAGER $PKG_INSTALL ${PACKAGES[@]}


##################
# Flatpaks
##################


echo -e "\033[0;92m\n\nInstalling/Checking packages from list ONLY FLATPACKS\n\n\e[0m"
$PKG_MANAGER $PKG_INSTALL flatpak

## Adds Flathub repository
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


PACKAGES_FILE2="./packages/packagesFlatpak.list"
if [ ! -f "$PACKAGES_FILE2" ]; then
    echo "Packages file $PACKAGES_FILE2 not found."
    exit 1
fi

PACKAGES=($(cat "$PACKAGES_FILE2"))

sudo flatpak install flathub ${PACKAGES[@]}


########################
# Snapd
########################


echo -e "\033[0;92m\n\nInstalling/Checking packages from list ONLY SNAPS\n\n\e[0m"

if is_package_installed "snapd"; then
	echo "Snapd it's already installed"
else
	
	echo "Snapd will be installed"
	
	$PKG_MANAGER addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
	$PKG_MANAGER --gpg-auto-import-keys refresh
	$PKG_MANAGER dup --from snappy
	$PKG_MANAGER $PKG_INSTALL snapd

	echo You then need to either reboot, logout/login

	sudo systemctl enable --now snapd
	sudo systemctl enable --now snapd.apparmor
	
fi

## Check for other packages to install
PACKAGES_FILE3="./packages/packagesSnap.list"
if [ ! -f "$PACKAGES_FILE3" ]; then
    echo "Packages file $PACKAGES_FILE3 not found."
    exit 1
fi

PACKAGES=($(cat "$PACKAGES_FILE3"))


sudo snap install ${PACKAGES[@]}


############################################
# Apps that cannot be installed as normal
############################################

echo Apps that cannot be installed as normal
echo -e "\033[0;93m\n\nSome apps must be installed manually, since the versions of the packages change every time and are not listed with Flatpaks, Snap, or a normal package manager\n\e[0m"

# List of URLs to open

PACKAGES_FILE4="./packages/packagesURL.list"
if [ ! -f "$PACKAGES_FILE4" ]; then
    echo "Packages file $PACKAGES_FILE4 not found."
    exit 1
fi

URLS=($(cat "$PACKAGES_FILE4"))

# Loop through the URLs and open each in a new tab
for url in "${URLS[@]}"; do
    xdg-open "$url"
done
echo -e "All app pages have been opened!\n"

#END
echo -e "\nSuccess! All your apps should be installed"

