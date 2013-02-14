Name: yaas-server	
Version: 0.4
Release: 1
Vendor: Paraguay Educa
Summary: Middleware between bios-crypto and yaas web interface
Group:	Applications/Internet
License: GPL
URL: http://git.paraguayeduca.org/git/users/mabente/yaas-server.git
Source0: %{name}-%{version}.tar.gz
Requires: ruby(abi) = 1.9.1, rubygems
BuildArch: noarch

Requires(pre): shadow-utils
Requires(post): systemd-units
Requires(preun): systemd-units
Requires(postun): systemd-units

%description
This application acts as a middleware layer between bios-crypto and the yaas web interface.


%prep
%setup -q


%build


%install
rm -rf $RPM_BUILD_ROOT

install -d $RPM_BUILD_ROOT/opt/%{name}/{etc,lib,log}
install -m 0755 yaas.rb $RPM_BUILD_ROOT/opt/%{name}
install -m 0644 lib/yaas*.rb $RPM_BUILD_ROOT/opt/%{name}/lib
install -m 0644 etc/yaas.config.example $RPM_BUILD_ROOT/opt/%{name}/etc

install -d $RPM_BUILD_ROOT/%{_unitdir}
install -m 0644 extra/yaas-server.service $RPM_BUILD_ROOT/%{_unitdir}


%pre
getent group yaas >/dev/null || groupadd -r yaas
getent passwd yaas >/dev/null || \
	useradd -r -g yaas -s /sbin/nologin \
		-c "yaas daemon user" yaas
exit 0


%post
%systemd_post yaas-server.service


%preun
%systemd_preun yaas-server.service


%postun
%systemd_postun_with_restart yaas-server.service


%files
%dir /opt/%{name}
/opt/%{name}/*.rb
/opt/%{name}/lib
/opt/%{name}/etc
%attr(-, yaas, yaas) /opt/%{name}/log
%{_unitdir}/*.service


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

