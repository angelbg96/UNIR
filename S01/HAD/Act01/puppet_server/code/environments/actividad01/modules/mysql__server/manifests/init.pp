class mysql::server (
    String $root_password,
    Boolean $remove_default_accounts = false,
) {

    package { 'mysql-server':
        ensure => installed,
    }

    service { 'mysql':
        ensure  => running,
        enable  => true,
        require => Package['mysql-server'],
    }

    if $remove_default_accounts {
        exec { 'remove_default_mysql_accounts':
            require     => Service['mysql'],
            command     => 'mysql -e "DELETE FROM mysql.user WHERE User=\'\' OR User=\'root\'"',
            refreshonly => true,
        }
    }

    exec { 'set_mysql_root_password':
        require     => Service['mysql'],
        command     => "mysqladmin -u root password '${root_password}'",
        refreshonly => true,
    }
}
