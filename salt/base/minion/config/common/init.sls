include:
  - minion.config.repo

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
    - unless:
      - test ! -d /home/lyve

install_pkgs:
  pkg.installed:
   - pkgs: {{ salt['pillar.get']('stx:pkgs:common') }}

#Needs to be refactored into a time module, respect and use pillar data!
set_time:
  cmd.run:
    - name: "systemctl stop ntp; ntpdate -s time.seagate.com"
    - require:
      - install_pkgs

set_time_done:
  grains.present:
    - name: ['stx:flag:configured_time']
    - value: True
    - require:
      - set_time

