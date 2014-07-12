Name:			arduino-mk
Version:		1.3.4
Release:		1%{dist}
Summary:		Program your Arduino from the command line
Packager:		Simon John <git@the-jedi.co.uk>
URL:            https://github.com/sudar/Arduino-Makefile
Source:         %{name}-%{version}.tar.gz
Group:			Development/Tools
License:		LGPLv2+
BuildRoot:		%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:		noarch
Requires:		arduino-core pyserial
BuildRequires:	arduino-core

%description
Arduino is an open-source electronics prototyping platform based on 
flexible, easy-to-use hardware and software. It's intended for artists, 
designers, hobbyists, and anyone interested in creating interactive 
objects or environments.

This package will install a Makefile to allow for CLI programming of the 
Arduino platform.

%prep
%setup -q

%install
mkdir -p %{buildroot}/%{_datadir}/arduino
mkdir -p %{buildroot}/%{_bindir}
mkdir -p %{buildroot}/%{_mandir}/man1
mkdir -p %{buildroot}/%{_docdir}/%{name}/examples
install -m 755 -d %{buildroot}/%{_docdir}/%{name}
install -m 755 -d %{buildroot}/%{_docdir}/%{name}/examples
for dir in `find examples -type d` ; do install -m 755 -d %{buildroot}/%{_docdir}/%{name}/$dir ; done
for file in `find examples -type f ! -name .gitignore` ; do install -m 644 $file %{buildroot}/%{_docdir}/%{name}/$file ; done
install -m 644 *.mk arduino-mk-vars.md %{buildroot}/%{_datadir}/arduino
install -m 644 licence.txt %{buildroot}/%{_docdir}/%{name}
install -m 755 bin/ard-reset-arduino %{buildroot}/%{_bindir}/ard-reset-arduino
install -m 644 ard-reset-arduino.1 %{buildroot}/%{_mandir}/man1

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_bindir}/ard-reset-arduino
%{_mandir}/man1/ard-reset-arduino.1*
%{_datadir}/arduino/*.mk
%{_datadir}/arduino/arduino-mk-vars.md
%doc %{_docdir}/%{name}/licence.txt
%docdir %{_docdir}/%{name}/examples
%{_docdir}/%{name}/examples

%changelog
* Sat Apr 12 2014 Simon John <git@the-jedi.co.uk>
- Put manpage back.
* Fri Apr 04 2014 Simon John <git@the-jedi.co.uk>
- Removed BuildRequires of python3/pyserial.
* Wed Apr 02 2014 Simon John <git@the-jedi.co.uk>
- Added BuildRequires of python3-pyserial. Need to look into Requires.
* Mon Mar 24 2014 Simon John <git@the-jedi.co.uk>
- Replaced perl/help2man with pyserial for reset script.
* Tue Feb 04 2014 Simon John <git@the-jedi.co.uk>
- Added arduino-mk-vars.md to the files to be installed/packaged.
* Sat Feb 01 2014 Simon John <git@the-jedi.co.uk>
- Updated version.
* Mon Jan 13 2014 Simon John <git@the-jedi.co.uk>
- Removed arduino-mk subdirectory
* Mon Dec 30 2013 Simon John <git@the-jedi.co.uk>
- Initial release.
