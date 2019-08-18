# osfingers: SLES-15 Ubuntu-18.04 'CentOS Linux-7'

{% set repo_suffix = grains['osfinger'] %}

include:
  - minion/states/repo/{{repo_suffix}}

