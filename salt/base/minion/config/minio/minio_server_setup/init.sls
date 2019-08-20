include:
  - minion.config.minio.minio_installed
  - minion.config.minio.minio_network

minio_disk_prep:
  cmd.run:
    - name: /root/benchmarks/MinioDiskPrep.sh
    - require:
      - copy_minio_tools
      - copy_benchmark_tools
      - test_log_dir_exists
stx_role:
  grains.present:
    - name: 'stx:role'
    - value: 'minio_server'
    - require:
      - minio_disk_prep
/etc/default/minio:
  file.managed:
    - source: salt://files/minio/ubuntu/minio.default
    - user: root
    - group: root
/etc/sysctl.conf:
  file.managed:
    - source: salt://files/minio/ubuntu/sysctls.conf
    - user: root
    - group: root
load_sysctls:
  cmd.run:
    - name: 'sysctl -p /etc/sysctl.conf'
    - require:
      - /etc/sysctl.conf
/etc/systemd/system/minio.service:
  file.managed:
    - source: salt://files/minio/ubuntu/minio.service
    - user: root
    - group: root
    - require:
      - /etc/default/minio
      - load_sysctls
minio_configured:
  grains.present:
    - name: stx:flag:minio_configured
    - value: True
    - require:
      - stx_role
      - minio_network_set
      - /etc/systemd/system/minio.service
