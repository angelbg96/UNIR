
node 'agt1.puppet.angel' {
    file { '/tmp/puppet_prueba':
        ensure => 'directory',
        owner => 'root',
        group => 'root',
        mode => '0755',
    }
}
