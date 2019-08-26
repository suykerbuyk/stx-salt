# osfingers: SLES-15 Ubuntu-18.04 'CentOS Linux-7'

{% set my_id = grains['id'] %}
{% set my_os = salt['pillar.get']('stx:node:' ~ my_id ~ ':os') %}
{% set repo_suffix = grains['osfinger'] %}

include:
  #    - 'minion/config/repo/{{repo_suffix}}'
    - 'minion/config/repo/{{my_os}}'

