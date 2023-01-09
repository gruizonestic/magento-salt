{% set php_pkgs_dict = salt['pillar.get']('php_packages') -%}
php:
  pkg.installed:
    - pkgs: 
      {% for key, value in php_pkgs_dict.items() -%}
      - {{ value }}
      {% endfor -%}  
  service.running:
    - name: php-fpm
    - enable: True

  file.managed:
    - names: 
      - /etc/php/8.1/cli/php.ini: 
        - source: salt://php/php.ini
      - /etc/php/8.1/fpm/php.ini: 
        - source: salt://php/php.ini
