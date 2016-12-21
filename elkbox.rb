#Champtc 2016 

#system(xterm -e *) used for ruby scripts and unfamiliar (to me) chef commands

#yum update
system('sudo yum update -y')

#xterm for popout terminals
system('sudo yum install xterm -y')

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

#static IP (in progress)
system('xterm -e ruby /etc/chef/staticip.rb')

#java
system('sudo wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u112-b15/jdk-8u112-linux-x64.rpm"')

system('sudo yum localinstall jdk-8u112-linux-x64.rpm -y')

system('sudo rm /jdk-8u112-linux-x64.rpm*')

#elasticsearch
system('sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch')

yum_repository "elasticsearch" do
	description 'Elasticsearch repository for 5.x packages'
	baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
	gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
	action :create
end

system('/bin/ssytemctl daemon-reload')
system('/bin/ssytemctl enable elastic.service')

#kibana
yum_repository "kibana" do
	description 'Kibana repository for 5.x packages'
	baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
	gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
	action :create
end

yum_package 'kibana' do
end

	#start service on startup
system('sudo /bin/systemctl daemon-reload')
system('sudo /bin/systemctl enable kibana.service')

#epel-release
yum_package 'epel-release' do
end

#Nginx
yum_package 'nginx' do
end

	#server block
system('xterm -e ruby /etc/chef/kibanaconf.rb')

#httpd-tools
yum_package 'httpd-tools' do
end

#http password
system('xterm -e ruby /etc/chef/kibanauser.rb')

#logstash
yum_repository "logstash" do
	description 'Elastic repository for 5.x packages'
	baseurl 'https://artifacts.elastic.co/packages/5.x/yum'
	gpgkey 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
	action :create
end

yum_package 'logstash' do
end

	#start service on startup
system('sudo /bin/systemctl daemon-reload')
system('sudo /bin/systemctl enable logstash.service')

	#plugins
system('sudo /usr/share/logstash/bin/logstash-plugin install logstash-output-stomp')
system('sudo /usr/share/logstash/bin/logstash-plugin install logstash-filter-tld')
system('sudo /usr/share/logstash/bin/logstash-plugin update')

#geoip 
directory '/var/local/geoip' do
 action :create
end
	#update
system('/etc/logstash/geo-update.bash > /dev/null 2>&1')

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
system('sudo systemctl stop firewalld')
system('sudo systemctl disable firewalld')

#activemq
system('chmod +x /etc/chef/activemq.sh')
system('./etc/chef/activemq.sh')


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
