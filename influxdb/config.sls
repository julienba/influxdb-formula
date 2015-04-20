include:
    - .cli
    - .admin

{% from "influxdb/map.jinja" import influxdb_settings with context %}

{% set admin_name = salt['pillar.get']('influxdb:user') %}
{% set admin_password = salt['pillar.get']('influxdb:password') %}


influxdb_start:
    service.running:
        - name: {{ influxdb_settings.service }}
        - enable: True

{% for database_name, user in salt["pillar.get"]("influxdb:databases", {}).iteritems() -%}
influxdb_{{ database_name }}_db:
    influxdb_database.present:
        - name: {{ database_name }}
        - user: {{ admin_name }}
        - password: {{ admin_password }}

    {% for username, user in salt["pillar.get"]("influxdb:databases:" + database_name + ":users", {}).iteritems() -%}
    influxdb_user.present:     
        - name: {{ username }}
        - passwd: {{ user.get('password') }}
        - database: {{ database_name }}
        - user: {{ admin_name }}
        - password: {{ admin_password }}
        - require:
            - influxdb_database: influxdb_{{ database_name }}_db
    {% endfor %}

{% endfor %}

