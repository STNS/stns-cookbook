chef_gem "toml" do
  action :install
  version '0.2.0'
  compile_time true if respond_to?(:compile_time)
end

require 'toml'
include_recipe 'stns'

package 'epel-release' if %w(rhel fedora).include?(node['platform_family'])

%w(
  libnss-stns-v2
  cache-stnsd
).each do |p|
  package p do
    action node['stns']['client']['package']['action']
  end
end

service 'cache-stnsd' do
  action %w(start enable)
end

file '/etc/stns/client/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  content lazy { TOML::Generator.new(node['stns']['client']).body }
  notifies :restart, 'service[cache-stnsd]'
end
