include:
    - minion.config.minio.minio_installed
stx_role:
  grains.present:
    - name: 'stx:role'
    - value: 'minio_client'
    - require:
      - copy_minio_tools
