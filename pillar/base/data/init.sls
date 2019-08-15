{% set stx_root_dir='/opt/stx' %}

stx:
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
    - base:
      {% if grains['os'] == 'Ubuntu' %}
      - vim
      {% elif grains['os'] == 'CentOS' %}
      - vim-enhanced
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
      - ntp-doc
      - ipmitool
      - moreutils
      - iperf3
      - sysstat
      - vnstat


