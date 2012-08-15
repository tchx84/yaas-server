Name: yaas-server	
Version: 0.3
Release: 1
Vendor: Paraguay Educa
Summary: Middleware between bios-crypto and yaas web interface
Group:	Applications/Internet
License: GPL
URL: http://git.paraguayeduca.org/git/users/mabente/yaas-server.git
Source0: %{name}-%{version}.tar.gz
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Requires: ruby(abi) = 1.9.1, rubygems, rubygem-daemons
BuildArch: noarch

%description
This application acts as a middleware layer between bios-crypto and the yaas web interface.

%prep
%setup -q

%build
%install
rm -rf $RPM_BUILD_ROOT

mkdir -p $RPM_BUILD_ROOT/opt/%{name}
cp -r * $RPM_BUILD_ROOT/opt/%{name}

mkdir -p $RPM_BUILD_ROOT/etc/init.d/
cp extra/yaas-server $RPM_BUILD_ROOT/etc/init.d/

# kill for packaging
rm -rf $RPM_BUILD_ROOT/opt/%{name}/test
rm -rf $RPM_BUILD_ROOT/opt/%{name}/etc/test.config
rm -rf $RPM_BUILD_ROOT/opt/%{name}/packaging
rm -rf $RPM_BUILD_ROOT/opt/%{name}/extra

%clean
rm -rf $RPM_BUILD_ROOT

%post
chkconfig --level 345 yaas-server on

%preun
chkconfig --level 345 yaas-server off

%postun

%files
%defattr(-,root,root,-)
%dir /opt/%{name}
/opt/%{name}/
%attr(755,root,root) /etc/init.d/yaas-server


%changelog
* Mon Dec  5 2011 Daniel Drake <dsd@laptop.org>
- Fix stopping of daemon
- Explain config format better

* Tue Aug 17 2010 Martin Abente. <mabente@paraguayeduca.org>
- Multithread support by Daniel Drake

* Mon Aug 16 2010 Martin Abente. <mabente@paraguayeduca.org>
- Small fixes and Documentation by Daniel Drake

* Fri Apr 30 2010 Martin Abente. <mabente@paraguayeduca.org>
- Packaging fixes
- Daemon auto start
- Improvements to ip validation system
- Force ip validation
- Change execution path hack

* Thu Apr 29 2010 Martin Abente. <mabente@paraguayeduca.org>
- ssl and secret keyword security

* Mon Apr 26 2010 Martin Abente. <mabente@paraguayeduca.org>
- Initial version

