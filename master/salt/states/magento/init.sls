magento:
  file.managed:
    - names: 
      - /var/www/html/var/composer_home/auth.json: 
        - source: salt://composer/auth.json.jinja
        - template: jinja
      - /usr/local/bin/install-magento.sh: 
        - source: salt://magento/install-magento.sh.jinja
        - template: jinja
    - mode: 755
    - makedirs: True

  cmd.run: 
    - name: /usr/local/bin/install-magento.sh
    - creates: /var/www/html/vendor

