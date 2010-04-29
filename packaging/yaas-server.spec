Name: yaas-server	
Version: 0.1
Release: 2
Vendor: Paraguay Educa
Summary: Middleware between bios-crypto and yaas web interface
Group:	Applications/Internet
License: GPL
URL: http://git.paraguayeduca.org/git/users/mabente/yaas-server.git
Source0: %{name}-%{version}.tar.gz
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Requires: ruby(abi) = 1.8, rubygems, rubygem-daemons
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

# kill packaging 
rm -rf $RPM_BUILD_ROOT/opt/%{name}/packaging
rm -rf $RPM_BUILD_ROOT/opt/%{name}/extra

%clean
rm -rf $RPM_BUILD_ROOT

%post

%postun

%files
%defattr(-,root,root,-)
%dir /opt/%{name}
/opt/%{name}/
/etc/init.d/

%changelog

* Thu Apr 29 2010 Martin Abente. <mabente@paraguayeduca.org>
- ssl and secret keyword security

* Mon Apr 26 2010 Martin Abente. <mabente@paraguayeduca.org>
- Initial version

