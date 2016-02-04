default['stns']['server']['port'] = 1104
default['stns']['server']['include'] = "/etc/stns/conf.d/*"

default['stns']['server']['users'] = [{}]
default['stns']['server']['groups'] = [{}]

default['stns']['client']['api_end_point'] = 'http://localhost:1104'
default['stns']['client']['chain_ssh_wrapper'] = nil

%w(passwd group).each do |s|
  default['nscd'][s]['enable_cache'] = true
  default['nscd'][s]['positive_time_to_live'] = 600
  default['nscd'][s]['negative_time_to_live'] = 300
  default['nscd'][s]['check_files'] = true
  default['nscd'][s]['shared'] = true
end

%w(hosts services netgroup).each do |s|
  default['nscd'][s]['enable_cache'] = false
end
