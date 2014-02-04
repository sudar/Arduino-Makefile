# How to compile an RPM

First install the dependencies as root:

    yum install arduino-core perl-Device-SerialPort help2man rpm-build

From the top-level Arduino-Makefile directory you've checked out of github, run the following (as unprivileged user) to create a compressed tarball using the naming conventions required by rpmbuild:

    git archive HEAD --prefix=arduino-mk-1.3.2/ -o ../arduino-mk-1.3.2.tar.gz

If you don't already have a rpmbuild setup (e.g. you've not installed the SRPM) you will need to create the directories:

    mkdir -p ~/rpmbuild/{SOURCES,SPECS}

Then copy the tarball and specfile into those directories:

    cp ../arduino-mk-1.3.2.tar.gz ~/rpmbuild/SOURCES/
    cp packaging/fedora/arduino-mk.spec ~/rpmbuild/SPECS/

Then compile. This will create a binary and source RPM:

    cd ~/rpmbuild/SPECS/
    rpmbuild -ba arduino-mk.spec

Fedora's AVR compilers use ccache, so you may have to override some of the paths to the AVR tools in your sketch's Makefile, for example:

    OVERRIDE_EXECUTABLES = 1
    CC                   = /usr/lib64/ccache/$(CC_NAME)
    CXX                  = /usr/lib64/ccache/$(CXX_NAME)
    AS                   = /usr/bin/$(AS_NAME)
    OBJCOPY              = /usr/bin/$(OBJCOPY_NAME)
    OBJDUMP              = /usr/bin/$(OBJDUMP_NAME)
    AR                   = /usr/bin/$(AR_NAME)
    SIZE                 = /usr/bin/$(SIZE_NAME)
    NM                   = /usr/bin/$(NM_NAME)
