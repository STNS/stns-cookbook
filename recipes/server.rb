include_recipe 'stns'
package 'stns'

template '/etc/stns/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[stns]'
end

directory '/etc/stns/conf.d' do
  mode '755'
  owner 'root'
  group 'root'
end

template '/etc/stns/conf.d/chef_users.conf' do
  mode '644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[stns]'
end

service 'stns' do
  action [:enable]
end
