#Champtc 12-21-2016

execute 'stop packagekitd (yum lock)' do
 action :run
 command 'systemctl stop packagekit.service'
end

#yum update
execute 'yum update' do
 action :run
 command 'yum update -y'
end

#ruby
yum_package 'ruby' do
end

#basic tools
yum_package 'wget' do
end

yum_package 'net-tools' do
end

yum_package 'nano' do
end

#change user pw
execute 'change user (vagrant) password' do
 action :run
 command 'xterm -e passwd vagrant'
end

#change root pw
execute 'change root password' do
 action :run
 command 'xterm -e passwd'
end

#static IP (in progress)
execute 'static ip setup' do
 action :run
 command 'xterm -e ruby /etc/chef/staticip.rb'
end

yum_package 'elasticsearch' do
end

yum_package 'kibana' do
end

#epel-release
yum_package 'epel-release' do
end

#Nginx
yum_package 'nginx' do
end

    #server block
execute 'create kibana.conf' do
 action :run
 command 'xterm -e ruby /etc/chef/kibanaconf.rb'
end

#httpd-tools
yum_package 'httpd-tools' do
end

#http password
execute 'configure kibana htaccess' do
 action :run
 command 'xterm -e ruby /etc/chef/kibanauser.rb'
end

yum_package 'logstash' do
end

execute 'plugin update' do
 action :run
 command 'sudo /usr/share/logstash/bin/logstash-plugin update'
end

#geoip update
system('/etc/logstash/geo-update.bash > /dev/null 2>&1')

#activemq
execute 'makes activemq.sh executable' do
 action :run
 command 'chmod +x /etc/chef/activemq.sh'
end
execute 'installs activemq' do
 action :run
 command './etc/chef/activemq.sh'
end

execute 'start packagekitd (was stopped)' do
 action :run
 command 'systemctl start packagekit.service'
end
