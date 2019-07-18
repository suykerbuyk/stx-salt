copy_benchmark_tools:
  file.recurse:
    - name: "/root/benchmarks"
    - source: salt://files/benchmarks
    - dir_mode: 0755
    - file_mode: 0755
    - user: root
    - group: root

