{% set stx_root_dir='/opt/stx' %}
{% set stx_log_dir='/var/log/stx' %}

stx:
  - timezone:
    - 'America/Denver'
  - timeserver:
    - 'time.seagate.com'
  - users:
    - lyve:
      - fullname: "Lyve Labs"
      - password: "clandestine"
  - dirs:
    - salt: "{{ stx_root_dir }}/stx-salt"
    - dnsmasq: "{{ stx_root_dir }}/stx-dnsmasq"
    - nginx: "{{ stx_root_dir }}/stx-nginx"
    - docker: "{{ stx_root_dir }}/stx-docker"
    - done_dir: "{{ stx_log_dir }}/stx-done"
    - minio_test_logs: "{{ stx_log_dir }}/minio_test_logs"
  - pkgs:
    - common:
      {% if grains['os'] == 'Ubuntu' %}
      - vim
      - tmux
      - ntpdate
      - ntp-doc
      - moreutils
      - iperf3
      {% elif grains['os'] == 'CentOS' %}
      - vim-enhanced
      - tmux
      - ntpdate
      - ntp-doc
      {% elif grains['os'] == 'SUSE' %}
      - vim
      {% elif grains['os'] == 'FreeBSD' %}
      - vim
      {% else %}
      - vim
      {% endif %}
      - ntp
      - ipmitool
      - iperf
      - sysstat
      - vnstat
  - minio:
    - log_dir: '/var/log/minio_test'
  - role:
    - 4u100-1a: minio_server
    - 4u100-1b: minio_server
    - 4u100-2a: minio_server
    - 4u100-2b: minio_server
    - lr02u30: minio_client
