copy_benchmark_tools:
  file.recurse:
    - name: "/root/benchmarks"
    - source: salt://files/benchmarks
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root

copy_minio_tools:
  file.recurse:
    - name: "/usr/local/bin"
    - source: salt://files/minio/ubuntu
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root

