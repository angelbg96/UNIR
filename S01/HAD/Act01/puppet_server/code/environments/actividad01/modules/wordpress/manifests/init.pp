class wordpress {
    include wordpress::params
    # Dependencias
    include apache

    class { 'mysql::server':
        root_password           => $wordpress::params::db_root_password,
        remove_default_accounts => $wordpress::params::db_remove_acc,
    }

    # Base de datos para WordPress
    package { 'php-mysqli':
        ensure => installed,
        require => Package['php'],
        notify  => Service['apache2'],
    }

    mysql::db { 'wordpress':
        user     => $wordpress::params::db_wp_user,
        password => $wordpress::params::db_wp_pass,
        host     => 'localhost',
        grant    => ['ALL'],
    }

    # Descargar e instalar WP
    file { '/var/www/html/wordpress':
        ensure  => directory,
        owner   => 'www-data',
        group   => 'www-data',
        mode    => '0755',
        require => Package['apache2'],
    }

    exec { 'download_wordpress':
        command     => '/usr/bin/wget https://wordpress.org/latest.tar.gz -P /tmp',
        creates     => '/tmp/latest.tar.gz',
        unless      => '/usr/bin/test -f /var/www/html/wordpress/index.php',
    }

    exec { 'extract_wordpress':
        command     => '/usr/bin/tar -xzf /tmp/latest.tar.gz -C /var/www/html/wordpress --strip-components=1',
        cwd         => '/tmp',
        creates     => '/var/www/html/wordpress/index.php',
        require     => [
            File['/var/www/html/wordpress'],
            Exec['download_wordpress'],
        ],
        unless      => '/usr/bin/test -f /var/www/html/wordpress/index.php',
    }

    # Configurar permisos y propietario
    exec { 'set_wordpress_permissions':
        command     => '/usr/bin/chown -R www-data:www-data /var/www/html/wordpress',
        require     => Exec['extract_wordpress'],
        unless      => '/usr/bin/find /var/www/html/wordpress -not -user www-data -o -not -group www-data -print -quit | /usr/bin/grep .',
    }

    # Configurar Wordpress
    file { '/var/www/html/index.html':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        source => 'puppet:///modules/wordpress/index.html',
        require => Exec['extract_wordpress'],
    }

    file { '/var/www/html/wordpress/wp-config.php':
        ensure  => present,
        owner   => 'www-data',
        group   => 'www-data',
        content => template('wordpress/wp-config.php.erb'),
        require => [
            Exec['extract_wordpress'],
            File['/var/www/html/index.html'],
        ],
        notify  => Service['apache2'],
    }

}
 