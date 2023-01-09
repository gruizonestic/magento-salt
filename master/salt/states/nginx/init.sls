nginx:
  pkg.installed:
    - name: nginx
  file.managed:
    - name: /etc/nginx/conf.d/default.conf
    - source: salt://nginx/default.conf.jinja
    - template: jinja
    - mode: 644
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/conf.d/default.conf

  
