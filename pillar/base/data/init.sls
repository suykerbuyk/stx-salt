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
    - test_logs:  "{{ stx_log_dir }}/test_logs"
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
      - less
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
  - node:
    - 4u100-1a:
      - os: ubuntu-18_04
      - role:
        - minio_server
    - 4u100-1b:
      - os: ubuntu-18_04
      - role:
        - minio_server
    - 4u100-2a:
      - os: ubuntu-18_04
      - role:
        - minio_server
    - 4u100-2b:
      - os: ubuntu-18_04
      - role:
        - minio_server
    - lr02u30:
      - os: ubuntu-18_04
      - role:
        - minio_client
    - lr02u34:
      - os: ubuntu-18_04
      - role:
        - minio_client
    - lr01u14:
      - os: sles-15sp1
      - role:
        - ceph_osd
    - lr01u22:
      - os: sles-15sp1
      - role:
        - ceph_osd
    - lr01u24:
      - os: sles-15sp1
      - role:
        - ceph_osd
    - lr01u32:
      - os: sles-15sp1
      - role:
        - ceph_osd
    - lr01u34:
      - os: sles-15sp1
      - role:
        - ceph_client
    - lr01u37:
      - os: sles-15sp1
      - role:
        - ceph_client
