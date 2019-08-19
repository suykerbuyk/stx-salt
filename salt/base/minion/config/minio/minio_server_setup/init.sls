include:
  - minion.config.minio.minio_installed

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

minio_disk_prep_done:
  grains.present:
    - name: stx:done:minio_disk_prep
    - value: True
    - require:
      - stx_role
