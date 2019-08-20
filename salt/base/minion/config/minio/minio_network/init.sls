set_minio-1_ip:
  host.present:
    - ip: 172.20.2.30
    - name: minio-1
set_minio-2_ip:
  host.present:
    - ip: 172.20.2.32
    - name: minio-2
set_minio-3_ip:
  host.present:
    - ip: 172.20.2.34
    - name: minio-3
set_minio-4_ip:
  host.present:
    - ip: 172.20.2.36
    - name: minio-4
minio_network_set:
  grains.present:
    - name: 'stx:flag:configured_minio_network'
    - value: True
    - require:
      - set_minio-1_ip
      - set_minio-2_ip
      - set_minio-3_ip
      - set_minio-4_ip
