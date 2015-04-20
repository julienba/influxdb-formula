include:
    - .cli

{% from "influxdb/map.jinja" import influxdb_settings with context %}
{% set admin_password = salt['pillar.get']('influxdb:password') %}


{% if salt['grains.get']('influxdb_admin_never_run', True) %}

First run:
    grains.present:
        - name: influxdb_admin_never_run
        - value: False

influxdb_start:
  service.running:
    - name: {{ influxdb_settings.service }}
    - enable: True

influxdb_root_pwd:
    module.run:
        - name: influxdb.user_chpass
        - m_name: root
        - passwd: {{ admin_password }}
        - user: root
        - password: root
        - require:
            - service: influxdb_start

{% endif %}
