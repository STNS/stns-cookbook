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

service 'stns-v2' do
  action [:enable]
end
h = node['stns']['server'].dup
h.delete("package")
file '/etc/stns/server/stns.conf' do
  mode '644'
  owner 'root'
  group 'root'
  content lazy { TOML::Generator.new(h).body }
  notifies :restart, 'service[stns]'
end
