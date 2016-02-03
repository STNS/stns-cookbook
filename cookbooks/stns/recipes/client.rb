include_recipe 'stns'
include_recipe 'nscd'

service 'nscd' do
  action [:start, :enable]
end

package 'libnss-stns'

template '/etc/stns/libnss_stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
end

cookbook_file '/etc/nsswitch.conf' do
  mode '644'
  owner 'root'
  group 'root'
end if node.environment == "develop-test"
