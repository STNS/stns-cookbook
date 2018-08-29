%w(curl sudo).each do |n|
  package n
end

c = nil
case node['platform_family']
when "rhel", "fedora"
  file '/etc/yum.repos.d/stns.repo' do
    content <<-EOS
[stns]
name=stns
baseurl=http://repo.stns.jp/centos/$basearch
gpgcheck=1
    EOS
    notifies :run, 'execute[add_repo_key]', :immediately
  end

  execute 'add_repo_key' do
    command <<-EOS
gpgkey_path=`mktemp`
curl -fsS -o $gpgkey_path https://repo.stns.jp/gpg/GPG-KEY-stns
rpm --import $gpgkey_path
rm $gpgkey_path
yum -y clean metadata
    EOS
    action :nothing
  end
when 'debian', 'ubuntu'
  file '/etc/apt/sources.list.d/stns.list' do
    content 'deb http://repo.stns.jp/debian/ stns main'
    notifies :run, 'execute[add_repo_key]', :immediately
  end

  execute 'add_repo_key' do
    command 'curl -fsS https://repo.stns.jp/gpg/GPG-KEY-stns| apt-key add - && apt-update -qqy'
    action :nothing
  end
end

