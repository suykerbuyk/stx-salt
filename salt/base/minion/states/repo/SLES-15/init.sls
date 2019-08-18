{% set suse_repo_base_url = "http://mgmt.lyve.colo.seagate.com/repo/suse15sp1/pkg" %}

suse_repo_purge:
  cmd.run:
    - name: 'rm -f /etc/zypp/repos.d/*.repo && echo $(date) >>/etc/zypp/repos.d/purge.done'
    - unless:
      - test -f '/etc/zypp/repos.d/purge.done'


repo_add_SLE-15-SP1-Installer:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Installer-DVD-x86_64-GM-DVD1"
    - enabled: True
    - name: SLE-15-SP1-Installer
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge


repo_add_SUSE-Enterprise-Storage-6:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SUSE-Enterprise-Storage-6-DVD-x86_64-GM-DVD1/"
    - enabled: True
    - name: SUSE-Enterprise-Storage-6
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge


repo_add_SUSE-Product-SLES:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Product-SLES/"
    - enabled: True
    - name: SUSE-Product-SLES
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge

repo_add_SUSE-Module-Basesystem:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Basesystem/"
    - enabled: True
    - name: SUSE-Module-Basesystem
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge

repo_add_SUSE-Module-Containers:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Containers/"
    - enabled: True
    - name: SUSE-Module-Containers
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge

repo_add_SUSE-Module-Development-Tools:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Development-Tools/"
    - enabled: True
    - name: SUSE-Module-Development-Tools
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge

repo_add_SUSE-Module-Server-Applications:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Server-Applications/"
    - enabled: True
    - name: Module-Server-Applications
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge

repo_add_SUSE-Module-Module-Legacy:
  pkgrepo.managed:
    - baseurl: "{{ suse_repo_base_url }}/SLE-15-SP1-Packages-x86_64-GM-DVD1/Module-Legacy/"
    - enabled: True
    - name: Module-Legacy
    - comments: "Lyve Labs Internal Mirror of SuSE upstream"
    - gpgautoimport: True
    - require:
      - cmd: suse_repo_purge
