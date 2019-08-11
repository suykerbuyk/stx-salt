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
