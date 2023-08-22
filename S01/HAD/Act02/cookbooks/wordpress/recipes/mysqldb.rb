
package 'mysql-server' do
    action :install
end

service 'mysql' do
    supports status: true, restart: true, reload: true
    action [:start, :enable]
end

execute 'exec_all_users' do
    cwd '/var/run'
    command 'chmod 755 mysqld'
    notifies :reload, 'service[apache]', :immediately
    only_if { shell_out('stat -c %a mysqld').stdout.chomp != '755' }
end

execute 'set_root_pass' do
    command "mysqladmin -u root password '#{node.default['mysql']['db_root_password']}'"
end
