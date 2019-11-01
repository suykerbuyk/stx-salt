salt-minion:
  pkg.installed

iputils:
  pkg.installed

/etc/salt/minion:
  file.managed:
    - source: salt://files/ceph/minion
    - user: root
    - group: root

/sbin/zeroDisk.sh:
  file.managed:
    - source: salt://files/bin/zeroDisk.sh
    - user: root
    - group: root
    - mode: 755

salt-minion.service:
  service.running:
    - reload: True
    - enable: True
    - watch:
      - /etc/salt/minion
