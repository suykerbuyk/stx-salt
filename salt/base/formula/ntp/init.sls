# Include :download:`map file <map.jinja>` of OS-specific package names and
# file paths. Values can be overridden using Pillar.
{% from "ntp/map.jinja" import ntp with context %}
{% set service = {True: 'running', False: 'dead'} %}

{% if 'package' in ntp.lookup %}
ntp:
  pkg.installed:
    - name: {{ ntp.lookup.package }}
{% endif %}

{% if 'ntp_conf' in ntp.lookup %}
ntpd_conf:
  file.managed:
    - name: {{ ntp.lookup.ntp_conf }}
    - source: salt:///formula/ntp/files/ntp.conf
    - template: jinja
    - context:
      config: {{ ntp.settings.ntp_conf|json }}
    - watch_in:
      - service: {{ ntp.lookup.service }}
    {% if 'package' in ntp.lookup %}
    - require:
      - pkg: ntp
    {% endif %}
{% endif %}

{% if 'ntpd' in ntp.settings %}
{%   set service_state = service.get(ntp.settings.ntpd) %}
{#   Do not attempt to run the service in a container where the service is configured with #}
{#   `ConditionVirtualization=!container` or similar (e.g. via. `kitchen-salt`) #}
{%   if grains.os_family in ['Suse'] and
        salt['grains.get']('virtual_subtype', '') in ['Docker', 'LXC', 'kubernetes', 'libpod'] %}
{%     set service_state = 'dead' %}
{%   endif %}
ntpd:
  service.{{ service_state }}:
    - name: {{ ntp.lookup.service }}
    - enable: {{ ntp.settings.ntpd }}
    {%- if 'init_delay' in ntp.settings %}
    - init_delay: {{ ntp.settings.init_delay }}
    {% endif %}
    {% if 'provider' in ntp.lookup %}
    - provider: {{ ntp.lookup.provider }}
    {% endif %}
    {% if 'package' in ntp.lookup %}
    - require:
      - pkg: ntp
    {% endif %}
    - watch:
      - file: ntpd_conf
{% endif %}
