case node['platform_family']
when "rhel", "fedora"
  shell = 'yum-repo.sh'
  repo_file = '/etc/yum.repos.d/stns.repo'
when 'debian', 'ubuntu'
  shell = 'apt-repo.sh'
  repo_file = '/etc/apt/sources.list.d/stns.list'
end

execute 'install_repo' do
  command "curl -fsSL #{node['stns']['repo']}/scripts/#{shell} | sh"
  not_if "test -e #{repo_file}"
end
