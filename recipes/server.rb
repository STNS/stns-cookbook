include_recipe 'stns'

package 'stns-v2' do
  retries 3
  retry_delay 10
  action node['stns']['server']['package']['action']
end

directory '/etc/stns/server/conf.d' do
  mode '755'
  owner 'root'
  group 'root'
end

service 'stns' do
  action node['stns']['server']['service']['action']
end

h = node['stns']['server'].dup
h.delete("package")
h.delete("service")
file '/etc/stns/server/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  content lazy { TOML::Generator.new(h).body }
  notifies :restart, 'service[stns]'
end
