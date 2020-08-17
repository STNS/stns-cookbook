
default['stns']['repo'] = 'https://repo.stns.jp'
default['stns']['server']['port'] = 1104
default['stns']['server']['include'] = "/etc/stns/conf.d/*"
default['stns']['server']['user'] = ""
default['stns']['server']['password'] = ""

default['stns']['server']['users'] = [{}]
default['stns']['server']['groups'] = [{}]
default['stns']['server']['sudoers'] = [{}]
default['stns']['server']['package']['action']= :install

default['stns']['client']['api_endpoint'] = 'http://localhost:1104/v1'
default['stns']['client']['user'] = nil
default['stns']['client']['password'] = nil
default['stns']['client']['chain_ssh_wrapper'] = nil
default['stns']['client']['ssl_verify'] = true
default['stns']['client']['query_wrapper'] = nil
default['stns']['client']['request_timeout'] = 3
default['stns']['client']['request_retry'] = 3
default['stns']['client']['http_proxy'] = nil
default['stns']['client']['package']['action']= :install
