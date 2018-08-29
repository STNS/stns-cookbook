chef_gem "toml" do
  action :install
  version '0.1.2'
  compile_time true if respond_to?(:compile_time)
end

require 'toml'
include_recipe 'stns'

package 'epel-release' if %w(rhel fedora).include?(node['platform_family'])

%w(
  libnss-stns-v2
).each do |p|
  package p
end

file '/etc/stns/client/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  content lazy { TOML::Generator.new(node['stns']['client']).body }
end
