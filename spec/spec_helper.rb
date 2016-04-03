require 'serverspec'

set :backend, :exec

def i386?
  Specinfra.backend.run_command("gcc -v 3>&2 2>&1 1>&3 | grep -e '--build=i386' -e '--build=i686'").exit_status == 0
end

def sudo_auth(user, password)
<<-EOS
sudo -u #{user} expect -c \"
set timeout 1
spawn sudo echo 'sudo success!!!'
expect {
  default {exit 1}
  \\"password\\" {
    send \\"#{password}\\n\\"
  }
}
expect {
  timeout {exit 1}
  eof
}
\"
EOS
end
