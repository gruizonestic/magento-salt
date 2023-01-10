composer_config_file1:
  file.managed:
    - name: /root/.config/composer/auth.json
    - source: salt://composer/auth.json.jinja
    - template: jinja
    - makedirs: true

composer:
  pkg.installed:
    - name: unzip
    
  environ.setenv:
    - name: variables
    - value: 
        COMPOSER_HOME: /root/.config/composer
        COMPOSER_ALLOW_SUPERUSER: '1'
    - update_minion: True

  cmd.run: 
    - name: curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    - creates: /usr/local/bin/composer

create_project:
  cmd.run:
    - name: composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition /var/www/html
    - creates: /var/www/html/vendor
