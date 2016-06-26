chef_gem "toml" do
  action :install
  compile_time true if respond_to?(:compile_time)
end

require 'toml'
include_recipe 'stns'
include_recipe 'nscd'

service 'nscd' do
  action [:start, :enable]
end

%w(libnss-stns libpam-stns).each do |p|
  package p
end

file '/etc/stns/libnss_stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  content lazy { TOML::Generator.new(node['stns']['client']).body }
  notifies :restart, 'service[nscd]'
end
