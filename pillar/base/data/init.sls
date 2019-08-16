{% set stx_root_dir='/opt/stx' %}

stx:
  - timeserver:
    - 'time.seagate.com'
  - users:
    - lyve:
      - fullname: "Lyve Labs"
      - password: "clandestine"
  - dirs:
    - done_dir: "{{ stx_root_dir }}/stx-done"
    - salt: "{{ stx_root_dir }}/stx-salt"
    - dnsmasq: "{{ stx_root_dir }}/stx-dnsmasq"
    - nginx: "{{ stx_root_dir }}/stx-nginx"
    - docker: "{{ stx_root_dir }}/stx-docker"
  - pkgs:
    - common:
      {% if grains['os'] == 'Ubuntu' %}
      - vim
      - ntp-doc
      {% elif grains['os'] == 'CentOS' %}
      - vim-enhanced
      - ntp-doc
      {% elif grains['os'] == 'SUSE' %}
      - vim
      {% elif grains['os'] == 'FreeBSD' %}
      - vim
      {% else %}
      - vim
      {% endif %}
      - tmux
      - ntp
      - ntpdate
      - ipmitool
      - moreutils
      - iperf
      - iperf3
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
