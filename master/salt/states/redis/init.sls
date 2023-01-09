redis:
  pkg.installed:
    - name: redis
  service.running:
    - watch:
      - pkg: redis