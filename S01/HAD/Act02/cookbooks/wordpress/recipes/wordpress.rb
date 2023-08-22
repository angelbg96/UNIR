# Descargar cookbooks dependencias:
# - MySQL : https://supermarket.chef.io/cookbooks/mysql
# - apparmor : https://supermarket.chef.io/cookbooks/apparmor
# - line : https://supermarket.chef.io/cookbooks/line

package 'php-mysqli' do
    action :install
    notifies :reload, 'service[apache]', :immediately
end

mysql_database 'wordpress' do
    host 'localhost'
    user 'root'
    password "#{node.default['mysql']['db_root_password']}"
    action :create
    not_if do
        File.exist?("#{node.default['apache']['document_root']}/wp-config.php")
    end
end

mysql_user "#{node.default['wordpress']['db_user']}" do
    password "#{node.default['wordpress']['db_pass']}"
    database_name "#{node.default['wordpress']['db_name']}"
    host 'localhost'
    privileges [:all]
    action [:create, :grant]
    not_if do
        File.exist?("#{node.default['apache']['document_root']}/wp-config.php")
    end
end

# Descargar WP CLI
remote_file '/usr/local/bin/wp' do
    source 'https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    not_if do
        File.exist?("#{node.default['apache']['document_root']}/wp-admin")
    end
end
# Instalar wordpress desde WP CLI
execute 'install_Wordpress' do
    cwd "#{node.default['apache']['document_root']}"
    command 'wp core download --locale=es_MX --allow-root'
    not_if do
        File.exist?("#{node.default['apache']['document_root']}/wp-admin")
    end
end

execute 'cambia_propietario' do
    cwd "#{node.default['apache']['document_root']}"
    command 'chown -R www-data:www-data ./'
    only_if { shell_out("find ./ ! -user www-data -o ! -group www-data").stdout.chomp != '' }
end

execute 'bkp_wpconfig' do
    cwd "#{node.default['apache']['document_root']}"
    command 'cp wp-config.php wp-config.php.bkp'
    only_if do
        File.exist?("#{node.default['apache']['document_root']}/wp-config.php")
    end
end
# Configura wordpress
template "#{node.default['apache']['document_root']}/wp-config.php" do
    source 'wp-config.php.erb'
    owner 'www-data'
    group 'www-data'
    mode '0644'
    notifies :reload, 'service[apache]', :immediately
end

# execute 'parametriza_Wordpress' do
#     cwd "#{node.default['apache']['document_root']}"
#     command "wp core install --allow-root --url=localhost \
#     --title='#{node.default['wordpress']['title_blog']}' \
#     --admin_user='#{node.default['wordpress']['db_user']}' \
#     --admin_password='#{node.default['wordpress']['db_pass']}' \
#     --admin_email='#{node.default['wordpress']['email']}'"
#     only_if do
#         File.exist?("#{node.default['apache']['document_root']}/wp-config.php")
#     end
# end

execute 'bkp_index' do
    cwd "#{node.default['apache']['document_root']}"
    command 'cp index.html index.html.ori'
    not_if do
        File.exist?("#{node.default['apache']['document_root']}/index.html.ori")
    end
end

cookbook_file "#{node['apache']['document_root']}/index.html" do
    source 'index.html'
    only_if do
        File.exist?("#{node['apache']['document_root']}/index.php")
    end
end
