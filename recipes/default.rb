%w(curl sudo).each do |n|
  package n
end

c = nil
case node['platform_family']
when "rhel", "fedora"
  yum_repository 'stns' do
    description "stns"
    baseurl "https://repo.stns.jp/centos/$basearch"
    gpgkey 'https://repo.stns.jp/gpg/GPG-KEY-stns'
    action :create
  end
when 'debian', 'ubuntu'
  apt_repository 'stns' do
    uri 'http://repo.stns.jp/debian/'
    distribution 'stns'
    components ["main"]
    key 'https://repo.stns.jp/gpg/GPG-KEY-stns'
    action :add
  end
end

