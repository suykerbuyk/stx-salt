{% set access_key = salt['pillar.get']('stx:keys:minio_server:access') %}
{% set secret_key = salt['pillar.get']('stx:keys:minio_server:secret') %}
{% set loops = salt['pillar.get']('stx:s3-benchmark:loops') %}
{% set duration = salt['pillar.get']('stx:s3-benchmark:duration') %}
{% set my_id = grains['id'] %}
{% set tgt_url = salt['pillar.get']('stx:s3-benchmark:' ~ my_id ~ ':target') %}

T01M01:
  s3-bench.mark:
    - access_key: {{ access_key }}
    - secret_key: {{ secret_key }}
    - obj_size: 1M
    - threads: 1
    - duration: {{ duration }}
    - loops: {{ loops }}
    - bucket: {{ my_id }}
    - tgt_url: {{ tgt_url }}

