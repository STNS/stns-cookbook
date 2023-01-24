whyrun_config = Chef::Config[:why_run]
begin
  Chef::Config[:why_run] = false
  chef_gem 'toml' do
    action :install
    compile_time true if respond_to?(:compile_time)
  end
ensure
  Chef::Config[:why_run] = whyrun_config
end

require 'toml'
include_recipe 'stns'

package 'epel-release' if %w[rhel fedora].include?(node['platform_family'])

%w[
  libnss-stns-v2
  cache-stnsd
].each do |p|
  package p do
    action node['stns']['client']['package']['action']
  end
end

service 'cache-stnsd' do
  action %w[start enable]
end

h = node['stns']['client'].dup
h.delete('package')
file '/etc/stns/client/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  content lazy { TOML::Generator.new(h).body }
  notifies :restart, 'service[cache-stnsd]'
end
