{% set test_log_dir = salt['pillar.get']('stx:dirs:test_logs') %}
{% set test_log_cpu = test_log_dir ~ '/lscpu.out' %}
{% set test_log_mem = test_log_dir ~ '/lsmem.out' %}
{% set test_log_fdisk = test_log_dir ~ '/fdisk.out' %}

include:
  - minion.config.common

copy_minio_tools:
  file.recurse:
    - name: "/usr/local/bin"
    - source: salt://files/minio/ubuntu/bin/
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root

copy_benchmark_tools:
  file.recurse:
    - name: "/root/benchmarks"
    - source: salt://files/benchmarks
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root
    - require:
      - copy_minio_tools

test_log_dir_exists:
  file.directory:
    - name: {{ test_log_dir }}
    - user: root
    - mode: 755
    - makedirs: True
    - require:
      - copy_benchmark_tools
