{% set test_log_dir = salt['pillar.get']('stx:dirs:test_logs') %}
{% set test_log_cpu = test_log_dir ~ '/lscpu.out' %}
{% set test_log_mem = test_log_dir ~ '/lsmem.out' %}
{% set test_log_fdisk = test_log_dir ~ '/fdisk.out' %}

include:
  - minion.config.minio.minio_installed
  - minion.config.minio.minio_server_setup

gather_cpu_info:
  cmd.run:
    - name: 'lscpu 2>&1 > {{ test_log_cpu }}'
    - require:
      - test_log_dir_exists
gather_mem_info:
  cmd.run:
    - name: 'lsmem 2>&1 > {{ test_log_mem }}'
    - require:
      - test_log_dir_exists
gather_fdisk_info:
  cmd.run:
    - name: 'fdisk -l 2>&1 > {{ test_log_fdisk }}'
    - require:
      - test_log_dir_exists
