# How to compile a Deb package

Use these instructions to build your own Deb package from your local sources.
For the latest official packages go to [Debian](http://packages.debian.org/arduino-mk)
or [Ubuntu](https://launchpad.net/ubuntu/+source/arduino-mk) or use apt.

First install the dependencies for building/running the package, as root:

    apt-get build-dep arduino-mk
    apt-get install arduino-core libdevice-serialport-perl help2man build-essential dpkg-dev fakeroot perl-doc devscripts

Fetch the Debian source:

    apt-get source arduino-mk

Make any local changes to want within the arduino-mk-* directory and update the package version:

    cd arduino-mk-*
    dch -i

Then compile. This will create a binary Deb:

    dpkg-buildpackage -b
