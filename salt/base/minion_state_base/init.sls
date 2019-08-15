{% set ntpdate_done_dir = salt['pillar.get']('stx:dirs:done_dir') %}
{% set ntpdate_done_flag =  salt['pillar.get']('stx:dirs:done_dir') ~ '/ntpdate.done' %}

{{ ntpdate_done_dir }}:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

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
   - pkgs: {{ salt['pillar.get']('stx:pkgs:base') }}
   - require:
      - {{ ntpdate_done_dir }}


fix_ubuntu_time:
  cmd.run:
    - name: "systemctl stop ntp; ntpdate -s time.seagate.com && date >> {{ ntpdate_done_flag }}"
    - require:
      - install_pkgs
      - {{ ntpdate_done_dir }}
    - unless:
      - test -f {{ ntpdate_done_flag }}

