#Champtc 12-21-2016

#yum update
execute 'yum update' do
 action :run
 command 'yum update -y'
end

#xterm for popout terminals
execute 'xterm' do
 action :run
 command 'yum install xterm -y'
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

#java
execute 'java get' do
 action :run
 command 'sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm"'
end

execute 'java install' do
 action :run
 command 'sudo yum localinstall jdk-8u112-linux-x64.rpm -y'
end

execute 'rm old jkd*' do
 action :run
 command 'sudo rm /jdk-8u112-linux-x64.rpm*'
end

#elasticsearch
execute 'import elasticsearch' do
 action :run
 command 'sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch'
end

yum_repository "elasticsearch" do
    description 'Elasticsearch repository for 5.x packages'
    baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
    gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    action :create
end

yum_package 'elasticsearch' do
end

#kibana
yum_repository "kibana" do
    description 'Kibana repository for 5.x packages'
    baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
    gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    action :create
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

#logstash
yum_repository "logstash" do
    description 'Elastic repository for 5.x packages'
    baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
    gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
    action :create
end

yum_package 'logstash' do
end


    #plugins
execute 'logstash-output-stomp plugin' do
 action :run
 command 'sudo /usr/share/logstash/bin/logstash-plugin install logstash-output-stomp'
end
execute 'logstash-filter-tld plugin' do
 action :run
 command 'sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-tld'
end
execute 'plugin update' do
 action :run
 command 'sudo /usr/share/logstash/bin/logstash-plugin update'
end

#geoip
directory '/var/local/geoip' do
 action :create
end
    #update
execute 'geoip update' do
 action :run
 command '/etc/logstash/geo-update.bash > /dev/null 2>&1'
end

#disable selinux
require 'tempfile'
 
        def file_edit(filename, regexp, replacement)
            Tempfile.open(".#{File.basename(filename)}", File.dirname(filename)) do |tempfile|
                File.open(filename).each do |line|
                tempfile.puts line .gsub(regexp, replacement)
            end
            tempfile.fdatasync
            tempfile.close
            stat = File.stat(filename)
            FileUtils.chown stat.uid, stat.gid, tempfile.path
            FileUtils.chmod stat.mode, tempfile.path
            FileUtils.mv tempfile.path, filename
            end
        end

        file_edit('/etc/sysconfig/selinux', 'enforcing', 'disabled')

#disable firewall
execute 'stop firewalld' do
 action :run
 command 'systemctl stop firewalld'
end
execute 'disable firewalld' do
 action :run
 command 'systemctl disable firewalld'
end

#activemq
execute 'makes activemq.sh executable' do
 action :run
 command 'chmod +x /etc/chef/activemq.sh'
end
execute 'installs activemq' do
 action :run
 command './etc/chef/activemq.sh'
end

#start services (elasticsearch, logstash, kibana) on startup
execute 'reload services' do
 action :run
 command '/bin/systemctl daemon-reload'
end
execute 'enable elastic search service' do
 action :run
 command '/bin/systemctl enable elasticsearch.service'
end

execute 'enable kibana search service' do
 action :run
 command '/bin/systemctl enable kibana.service'
end

execute 'enable logstash search service' do
 action :run
 command '/bin/systemctl enable logstash.service'
end

#CRON JOB
#geoip update
cron 'geoip update' do
    minute '0'
    hour '12'
    day '*'
    month '*'
    weekday '3'
    command '/etc/logstash/geo-update.bash > /dev/null 2>&1'
end
