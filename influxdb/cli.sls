cli_dependencies:
  pkg.installed:
    - pkgs:
{% if grains['os_family'] == 'Debian' %}
      - build-essential
      - ruby-dev
{% elif grains['os_family'] == 'RedHat' %}
      - gcc
      - make
      - automake
      - ruby-devel
{% endif %}
      - ruby

cli_gem:
  gem.installed:
    - name: influxdb-cli
    - require:
        - pkg: cli_dependencies


python-pip:
    pkg.installed

influxdb-python:
    pip.installed:
        - name: influxdb == 0.4.1
        - require:
            - pkg: python-pip
