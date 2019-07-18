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

install_pkgs:
  pkg.installed:
    - pkgs: ["vim","tmux","ntpdate"]

boot_strap_salt:
  cmd.run:
    - name: 'curl -L https://bootstrap.saltstack.com stable 2019.2.0 | sudo sh'
    - unless:
      - test -f /etc/salt/minion

set_minion_conf:
  file.managed:
    - name: /etc/salt/minion
    - source: salt://files/misc/default.lyve.labs.minion
    - user: root
    - group: root
    - mode: 0600

set_minion_pem:
  file.managed:
    - name: /etc/salt/pki/minion/minion.pem
    - source: salt://files/pki/default.lyve.labs.pem
    - user: root
    - group: root
    - mode: 0600

set_minion_pub:
  file.managed:
    - name: /etc/salt/pki/minion/minion.pub
    - source: salt://files/pki/default.lyve.labs.pub
    - user: root
    - group: root
    - mode: 0600

copy_benchmark_tools:
  file.recurse:
    - name: "/root/benchmarks"
    - source: salt://files/benchmarks
    - dirmode: 0755
    - filemode: 0755
    - user: root
    - group: root

copy_minio_tools:
  file.recurse:
    - name: "/usr/local/bin"
    - source: salt://files/minio/ubuntu
    - dirmode: 0755
    - filemode: 0755
    - user: root
    - group: root

salt-minion:
  service.running:
    - enable: True
    - reload: True

restart_salt_minion:
  cmd.run:
    - name: "systemctl restart salt-minion"
