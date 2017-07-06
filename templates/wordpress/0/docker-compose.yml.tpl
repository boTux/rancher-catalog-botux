db:
  image: mariadb
  environment:
    MYSQL_ROOT_PASSWORD: ${sql_root_password}
    MYSQL_DATABASE: ${sql_wordpress_name}
    MYSQL_USER: ${sql_wordpress_name}
    MYSQL_PASSWORD: ${sql_wordpress_password}
  volumes:
    - ${projet_name}-sql:/var/lib/mysql

wordpress:
  restart: always
  image: registry.enigm.com/sysadmin/docker/webapps/wordpress:latest
  environment:
    WORDPRESS_DB_PASSWORD: ${sql_wordpress_password}
    WORDPRESS_DB_USER: ${sql_wordpress_name}
    WORDPRESS_DB_NAME: ${sql_wordpress_name}
  volumes:
    - ${projet_name}-www:/var/www/html
  links:
    - db:mysql
  labels:
    io.rancher.container.hostname_override: container_name
    io.rancher.container.pull_image: always
    traefik.enable: ${lb_enable}
    traefik.domain: ${lb_domain}
    traefik.protocol: http
    traefik.alias.fqdn: ${domain}
    traefik.port: 80
    traefik.acme: ${letsencrypt}
    traefik.frontend.passHostHeader: 'true'

