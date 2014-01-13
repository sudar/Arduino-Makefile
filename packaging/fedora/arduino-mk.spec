Name:			arduino-mk
Version:		1.2.0
Release:		1%{dist}
Summary:		Program your Arduino from the command line
Packager:		Simon John <git@the-jedi.co.uk>
URL:            https://github.com/sudar/Arduino-Makefile
Source:         %{name}-%{version}.tar.gz
Group:			Development/Tools
License:		LGPLv2+
BuildRoot:		%{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildArch:		noarch
Requires:		arduino-core, perl-Device-SerialPort
BuildRequires:	arduino-core, perl-Device-SerialPort, help2man

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
install -m 644 *.mk %{buildroot}/%{_datadir}/arduino
install -m 644 licence.txt %{buildroot}/%{_docdir}/%{name}
install -m 755 bin/ard-reset-arduino %{buildroot}/%{_bindir}/ard-reset-arduino
help2man %{buildroot}/%{_bindir}/ard-reset-arduino -n "Reset Arduino board" -s 1 -m "Arduino CLI Reset" --version-string=%{version} -N -o %{buildroot}/%{_mandir}/man1/ard-reset-arduino.1

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%{_bindir}/ard-reset-arduino
%{_mandir}/man1/ard-reset-arduino.1*
%{_datadir}/arduino/*.mk
%doc %{_docdir}/%{name}/licence.txt
%docdir %{_docdir}/%{name}/examples
%{_docdir}/%{name}/examples

%changelog
* Mon Jan 13 2014 Simon John <git@the-jedi.co.uk>
- Removed arduino-mk subdirectory
* Mon Dec 30 2013 Simon John <git@the-jedi.co.uk>
- Initial release.
