include:
    - minion.config.minio.minio_installed
    - minion.config.minio.minio_network
stx_role:
  grains.present:
    - name: 'stx:role'
    - value: 'minio_client'
    - require:
      - copy_minio_tools
      - minio_network_set
