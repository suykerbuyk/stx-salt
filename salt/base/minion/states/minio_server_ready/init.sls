include:
  - minion_state_base
  - minio_state_base

minio_disk_prep:
  cmd.run:
    - name: /root/benchmarks/MinioDiskPrep.sh
    - require:
      - copy_minio_tools
      - copy_benchmark_tools
