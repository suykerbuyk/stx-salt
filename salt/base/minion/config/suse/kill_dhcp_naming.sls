set_no_dhcp_network_name:
  file.line:
  - name: '/etc/sysconfig/network/dhcp'
  - content: 'DHCLIENT_SET_HOSTNAME="no"'
  - match: 'DHCLIENT_SET_HOSTNAME'
  - mode: replace

wicked.service:
  service.running:
  - enable: True
  - reload: True
  - force: True
  - watch:
    - set_no_dhcp_network_name
  - require:
    - set_no_dhcp_network_name
