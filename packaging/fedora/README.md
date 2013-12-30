# How to compile an RPM

First install the dependencies as root:

    yum install arduino-core perl-Device-SerialPort help2man rpm-build

From the top-level Arduino-Makefile directory you've checked out of github, run the following (as unprivileged user) to create a compressed tarball using the naming conventions required by rpmbuild:

    git archive --prefix=arduino-mk-1.1.0/ --format=tar -o ../arduino-mk-1.1.0.tar.gz -v HEAD | gzip

If you don't already have a rpmbuild setup (e.g. you've not installed the SRPM) you will need to create the directories:

    mkdir -p ~/rpmbuild/{SOURCES,SPECS}

Then copy the tarball and specfile into those directories:

    cp ../arduino-mk-1.1.0.tar.gz ~/rpmbuild/SOURCES/
    cp packaging/fedora/arduino-mk.spec ~/rpmbuild/SPECS/

Then compile. This will create a binary and source RPM:

    cd ~/rpmbuild/SPECS/
    rpmbuild -ba arduino-mk.spec
