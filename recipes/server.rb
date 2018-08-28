include_recipe 'stns'
package 'stns-v2'

template '/etc/stns/server/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  notifies :restart, 'service[stns]'
end

directory '/etc/stns/server/conf.d' do
  mode '755'
  owner 'root'
  group 'root'
end

service 'stns' do
  action [:enable]
end
