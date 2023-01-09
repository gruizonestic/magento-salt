elastic_memory:
  - min_memory: 512m
  - max_memory: 512m

elastic_path:
  - data: /var/lib/elasticsearch
  - log: /var/log/elasticsearch

elastic_config:
  - bootstrap_memory_lock: true
  - host: 127.0.0.1
  - port: 9200