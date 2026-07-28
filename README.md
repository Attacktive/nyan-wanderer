# Roameow

[![CodeFactor](https://www.codefactor.io/repository/github/attacktive/roameow-plasma/badge)](https://www.codefactor.io/repository/github/attacktive/roameow-plasma)
[![Release](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml/badge.svg)](https://github.com/Attacktive/Roameow-plasma/actions/workflows/release.yaml)

A fun Plasma 6 widget that features an animated Nyan Cat roaming around your desktop!

It's completely useless by design. 😏

[nyancat.webm](https://github.com/user-attachments/assets/96ee8750-bfcd-42e3-bd39-f4a3e9866a00)

[tacnayn.webm](https://github.com/user-attachments/assets/82953fea-b08c-4d74-8573-0629e01c540a)


## Installation

1. Make sure you have the required dependencies:
	- Arch Linux
	```bash
	$ sudo pacman -S base-devel extra-cmake-modules plasma-sdk gettext
	```
	- Ubuntu 24.04
	```bash
	# Adding KDE neon PPA to the containerized Ubuntu because it lacks dependencies for Plasma 6
	$ echo "deb [trusted=yes] http://archive.neon.kde.org/user noble main" | sudo tee /etc/apt/sources.list.d/neon.list
	$ sudo apt update
	$ sudo apt install build-essential kf6-extra-cmake-modules plasma-framework6-dev gettext
	```

2. Build and install the widget:
	```bash
	$ ./install.sh
	```

3. Add the widget to your desktop or panel through the Plasma widgets menu
