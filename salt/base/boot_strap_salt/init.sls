cp_termsize:
  file.managed:
    - name: /bin/termsize
    - source: salt://files/bin/termsize
    - user: root
    - group: root
    - mode: 755

cp_tmux_conf_root:
  file.managed:
    - name: "/root/.tmux.conf"
    - source: salt://files/misc/tmux.conf
    - user: root
    - group: root
    - mode: 755

cp_tmux_conf_lyve:
  file.managed:
    - name: "/home/lyve/.tmux.conf"
    - source: "salt://files/misc/tmux.conf"
    - user: lyve
    - group: lyve
    - mode: 755

force_ntpdate_install:
  cmd.run:
    - name: 'apt-get install ntpdate'
    - unless:
      - test -f /usr/sbin/ntpdate

fix_ubuntu_time:
  cmd.run:
    - name: 'ntpdate -s time.seagate.com; apt-get update'
    - require:
      - force_ntpdate_install

install_pkgs:
  pkg.installed:
    - pkgs: ["vim","tmux","ntp","ntp-doc"]
    - require:
      - fix_ubuntu_time

cp_salt_bootstrap:
  file.managed:
    - name: "/root/bootstrap-salt.sh"
    - source: "salt://files/misc/bootstrap-salt.sh"
    - user: root
    - group: root
    - mode: 755

boot_strap_salt:
  cmd.run:
    - name: '/root/bootstrap-salt.sh stable 2019.2.0'
    - unless:
      - test -f /etc/salt/minion
    - require:
      - cp_salt_bootstrap
      - install_pkgs 

set_minion_conf:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://files/misc/default.lyve.labs.minion
    - user: root
    - group: root
    - mode: 0600
    - require:
      - boot_strap_salt

set_minion_pem:
  file.managed:
    - name: /etc/salt/pki/minion/minion.pem
    - source: salt://files/pki/default.lyve.labs.pem
    - user: root
    - group: root
    - mode: 0600
    - require:
      - boot_strap_salt

set_minion_pub:
  file.managed:
    - name: /etc/salt/pki/minion/minion.pub
    - source: salt://files/pki/default.lyve.labs.pub
    - user: root
    - group: root
    - mode: 0600
    - require:
      - boot_strap_salt

copy_benchmark_tools:
  file.recurse:
    - name: "/root/benchmarks"
    - source: salt://files/benchmarks
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root

copy_minio_tools:
  file.recurse:
    - name: "/usr/local/bin"
    - source: salt://files/minio/ubuntu
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root

salt-minion.service:
  service.running:
    - enable: True
    - reload: True
    - require:
      - set_minion_pub
      - set_minion_pem
      - set_minion_conf

restart_salt_minion:
  cmd.run:
    - name: "systemctl restart salt-minion"
    - require:
      - salt-minion.service
