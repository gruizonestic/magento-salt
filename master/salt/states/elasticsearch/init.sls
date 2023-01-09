elasticsearch:
  pkgrepo.managed:
    - humanname: Elasticsearch Repo
    - name: deb https://artifacts.elastic.co/packages/7.x/apt stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/elastic-7.x.list
    - key_url: https://artifacts.elastic.co/GPG-KEY-elasticsearch
    - require_in: 
      - pkg: elasticsearch

  pkg.installed:
    - name: elasticsearch

  file.managed:
    - names: 
      - /etc/elasticsearch/jvm.options.d/jvm.options:
        - source: salt://elasticsearch/jvm.options.jinja
        - template: jinja
        - mode: 644
      - /etc/elasticsearch/elasticsearch.yml:
        - source: salt://elasticsearch/elasticsearch.yml.jinja
        - template: jinja
        - mode: 660

  service.running:
    - enable: True
    - watch:
      - file: /etc/elasticsearch/*
  