Name: yaas-server	
Version: 0.1
Release: 1
Vendor: Paraguay Educa
Summary: Middleware between bios-crypto and web interface
Group:	Applications/Internet
License: GPL
URL: http://git.paraguayeduca.org/git/users/mabente/yaas-server.git
Source0: %{name}-%{version}.tar.gz
BuildRoot: %(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
Requires: ruby(abi) = 1.8, rubygems, rubygem-daemons
BuildArch: noarch

%description
This application acts a middleware layer between the bios-crypto and a web interface. This web interface provides a user managed environment for generating leases and developer keys.

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
# rm -rf $RPM_BUILD_ROOT/opt/%{name}/packaging
# rm -rf $RPM_BUILD_ROOT/opt/%{name}/extra

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

* Mon Apr 26 2010 Martin Abente. <mabente@paraguayeduca.org>
- Initial version

