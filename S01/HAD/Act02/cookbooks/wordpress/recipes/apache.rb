
package 'Install Apache' do
    case node[:platform]
        when 'redhat', 'centos'
            package_name 'httpd'
        when 'ubuntu', 'debian'
            package_name 'apache2'
    end
    action :install
end

package 'php' do
    action :install
end

service 'apache' do
    case node['platform']
        when 'redhat', 'centos', 'scientific', 'fedora', 'amazon'
            service_name 'httpd'
        when 'debian', 'ubuntu', 'suse'
            service_name 'apache2'
    end
    supports status: true, restart: true, reload: true
    action [:start, :enable]
end
