mysql_debconf_install:
  pkg.installed:
    - name: debconf

mysql_debconf_utils:
  pkg.installed:
    - name: debconf-utils

mysql_server_install:
  pkg.installed:
    - name: mysql-server


mysql_setup:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': { 'type': 'string', 'value': 'password' }
        'mysql-server/root_password_again': { 'type': 'string', 'value': 'password' }

mysql_python_install:
  pkg.installed:
    - name: python3-mysqldb

{# mysql_server_config:
  file.managed:
    - name: /etc/mysql/mysql.conf.d/mysqld.cnf
    - makedirs: True
    - source: salt://mysql/deb_mysqld.cnf
    - require:
      - pkg: mysql-server #}

mysql-server:
  pkg:
    - installed
    - require:
      - debconf: mysql_setup
mysql_client_install:
  pkg.installed:
    - name: mysql-client

mysql_running:
  service.running:
    - name: mysql
    - enable: True

mysql-base:
  mysql_database.present:
    - name: {{salt['pillar.get']('magento_users:database')}}
    - connection_user: root
    - connection_pass: password
  mysql_user.present:
    - name: {{salt['pillar.get']('magento_users:username')}}
    - password: {{salt['pillar.get']('magento_users:password')}}
    - connection_user: root
    - connection_pass: password
  mysql_grants.present:
    - database: {{salt['pillar.get']('magento_users:database')}}.*
    - grant: ALL PRIVILEGES
    - user: {{salt['pillar.get']('magento_users:username')}}
    - connection_user: root
    - connection_pass: password
  
mysql_config:
  ini.options_present:
    - name: /etc/mysql/mysql.conf.d/mysqld.cnf
    - separator: '='
    - strict: True
    - sections:
        mysqld_safe:
          socket: {{salt['pillar.get']('mysql_configuration:socket')}}
          nice: {{salt['pillar.get']('mysql_configuration:nice')}}
        mysqld:
          user: {{salt['pillar.get']('mysql_configuration:user')}}
          pid-file: {{salt['pillar.get']('mysql_configuration:pid-file')}}
          socket: {{salt['pillar.get']('mysql_configuration:socket')}}
          port: {{salt['pillar.get']('mysql_configuration:port')}}
          basedir: {{salt['pillar.get']('mysql_configuration:basedir')}}
          datadir: {{salt['pillar.get']('mysql_configuration:datadir')}}
          tmpdir: {{salt['pillar.get']('mysql_configuration:tmpdir')}}
          lc-messages-dir: {{salt['pillar.get']('mysql_configuration:lc-messages-dir')}}
          bind-address: {{salt['pillar.get']('mysql_configuration:bind-address')}}
          key_buffer_size: {{salt['pillar.get']('mysql_configuration:key_buffer_size')}}
          max_allowed_packet: {{salt['pillar.get']('mysql_configuration:max_allowed_packet')}}
          thread_stack: {{salt['pillar.get']('mysql_configuration:thread_stack')}}
          thread_cache_size: {{salt['pillar.get']('mysql_configuration:thread_cache_size')}}
          myisam-recover-options: {{salt['pillar.get']('mysql_configuration:myisam-recover-options')}}
          log_error: {{salt['pillar.get']('mysql_configuration:log_error')}}
          expire_logs_days: {{salt['pillar.get']('mysql_configuration:expire_logs_days')}}
          max_binlog_size: {{salt['pillar.get']('mysql_configuration:max_binlog_size')}}

