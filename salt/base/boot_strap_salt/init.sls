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
