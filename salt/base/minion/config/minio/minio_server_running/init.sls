{% set test_log_dir = salt['pillar.get']('stx:dirs:test_logs') %}
{% set test_log_cpu = test_log_dir ~ '/lscpu.log' %}
{% set test_log_mem = test_log_dir ~ '/lsmem.log' %}
{% set test_log_fdisk = test_log_dir ~ '/fdisk.log' %}
{% set test_log_minio = test_log_dir ~ '/minio.log' %}
{% set minio_access_key = salt['pillar.get']('stx:keys:minio_server:access') %}
{% set minio_secret_key = salt['pillar.get']('stx:keys:minio_server:secret') %}

include:
  - minion.config.minio.minio_installed
  - minion.config.minio.minio_server_setup

gather_cpu_info:
  cmd.run:
    - name: 'lscpu 2>&1 > {{ test_log_cpu }}'
    - creates:
      - {{ test_log_cpu }}
    - require:
      - test_log_dir_exists
gather_mem_info:
  cmd.run:
    - name: 'lsmem 2>&1 > {{ test_log_mem }}'
    - creates:
      - {{ test_log_mem }}
    - require:
      - test_log_dir_exists
gather_fdisk_info:
  cmd.run:
    - name: 'fdisk -l 2>&1 > {{ test_log_fdisk }}'
    - creates:
      - {{ test_log_fdisk }}
    - require:
      - test_log_dir_exists
launch_minio_server:
  - cmd.run:
    - name: setsid /root/benchmarks/LaunchMinioServer.sh 2&1>{{test_log_minio}}
    - require:
      - gather_fdisk_info
