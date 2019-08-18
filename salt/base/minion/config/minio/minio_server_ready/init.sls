include:
  - config.minion_state_base
  - config.minio_state_base

minio_disk_prep:
  cmd.run:
    - name: /root/benchmarks/MinioDiskPrep.sh
    - require:
      - copy_minio_tools
      - copy_benchmark_tools

minio_prep_done_grain:
  grains.present:
    - name: stx:done:mini_disk_prep
    - value: True
    - require:
      - minio_disk_prep
