include_recipe 'stns'
package 'stns'

template '/etc/stns/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[stns]'
end if node.environment == "develop-test"

service 'stns' do
  action [:enable]
end
