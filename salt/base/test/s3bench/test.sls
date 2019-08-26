{% set access_key = salt['pillar.get']('stx:keys:minio_server:access') %}
{% set secret_key = salt['pillar.get']('stx:keys:minio_server:secret') %}
{% set loops = salt['pillar.get']('stx:s3-benchmark:loops') %}
{% set duration = salt['pillar.get']('stx:s3-benchmark:duration') %}
{% set my_id = grains['id'] %}
{% set tgt_url = salt['pillar.get']('stx:s3-benchmark:' ~ my_id ~ ':target') %}
{% set my_obj_size = salt['grains.get']('stx:s3-bench:obj_size') %}
{% set my_threads = salt['grains.get']('stx:s3-bench:threads') %}
{% set test_name = 'T' ~ my_threads ~ '_' ~ my_obj_size %}

{{test_name}}:
  s3-bench.mark:
    - access_key: {{ access_key }}
    - secret_key: {{ secret_key }}
    - obj_size: {{ my_obj_size }}
    - threads: {{ my_threads }}
    - duration: {{ duration }}
    - loops: {{ loops }}
    - bucket: {{ my_id }}
    - tgt_url: {{ tgt_url }}

