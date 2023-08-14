# DistroPacksInstaller
## Install your packages in any distribution

I created this Bash for the purpose of installing packages faster than attaching everything manually.

It helps especially when you want to do Distro-hopping.

This Bash allows you to install package managers for your distribution (apt, pacman, dnf or zypper), Flatpak and Snap, it also has a list of URLs for those that cannot be installed in any of the above ways.

## How to use this Bash

1. Download the file.
2. Unzip it.
3. Open the terminal where you unzipped the file.
4. Open the ´*.list´ files and write the packages you want to install.
	1. packages.list is where every native package you want to install (like .deb or .rpm).
	2. packagesFlatpak.list has all the Flatpak(s).
	3. packagesSnap.list has all the Snap(s).
	4. packagesURL.list has all the URLs of every package that you have to download from their site.
5. Type `sh packagesLinux.sh` and hit enter.
6. Follow the instructions that the script displays.

> [!caution]
> Run it at your own risk


## Do you have another idea?

Write it here! I'm open to any change.

## License
Licensed under MIT.
