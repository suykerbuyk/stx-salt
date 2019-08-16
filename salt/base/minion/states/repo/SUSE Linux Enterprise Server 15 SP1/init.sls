{% set suse_repo_base_url = "http://mgmt.lyve.colo.seagate.com/repo/suse15sp1/pkg" %}

suse_repo_purge:
  - cmd.run:
    - name: "rm -f /etc/zypp/repos.d/*.repo"

suse_repo_add_SLE-15-SP1-Installer:
  - cmd.run:
    - name: "zypper addrepo {{ suse_repo_base_url }}/SLE-15-SP1-Installer-DVD-x86_64-GM-DVD1/ SLE-15-SP1-Installer"
  - require:
    - suse_repo_purge


suse_repo_add_SUSE-Enterprise-Storage-6:
  - cmd.run:
    - name: "zypper addrepo {{ suse_repo_base_url }}/SUSE-Enterprise-Storage-6-DVD-x86_64-GM-DVD1 SUSE-Enterprise-Storage-6"
  - require:
    - suse_repo_purge


zypper addrepo {{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Product-SLES Product-SLES
zypper addrepo {{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Basesystem/ Module-Basesystem
zypper addrepo {{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Containers/ Module-Containers
zypper addrepo {{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Development-Tools/ Module-Development-Tools
zypper addrepo {{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Server-Applications/ Module-Server-Applications
zypper clean
