default['stns']['server']['port'] = 1104
default['stns']['server']['include'] = "/etc/stns/conf.d/*"

default['stns']['server']['users'] = [{}]
default['stns']['server']['groups'] = [{}]

default['stns']['client']['api_end_point'] = ['http://localhost:1104']
default['stns']['client']['chain_ssh_wrapper'] = nil
default['stns']['client']['ssl_verify'] = true

%w(passwd group).each do |s|
  default['nscd'][s]['enable_cache'] = 'yes'
  default['nscd'][s]['positive_time_to_live'] = 600
  default['nscd'][s]['negative_time_to_live'] = 300
  default['nscd'][s]['check_files'] = 'yes'
  default['nscd'][s]['shared'] = 'yes'
end

%w(hosts services netgroup).each do |s|
  default['nscd'][s]['enable_cache'] = 'no'
end
