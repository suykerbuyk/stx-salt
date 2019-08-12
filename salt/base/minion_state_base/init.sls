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
    - name: 'ntpdate -s time.seagate.com'
    - require:
      - force_ntpdate_install

install_pkgs:
  pkg.installed:
    - pkgs: ["vim","tmux","ntp","ntp-doc","ipmitool"]
    - require:
      - fix_ubuntu_time
