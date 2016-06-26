require 'toml'
include_recipe 'stns'
include_recipe 'nscd'

service 'nscd' do
  action [:start, :enable]
end

%w(libnss-stns libpam-stns).each do |p|
  package p
end

template '/etc/stns/libnss_stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  variables({ dump: Toml.dump(node['stns']['client']) })
  notifies :restart, 'service[nscd]'
end
