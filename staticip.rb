#static IP
prompt1 = 'New Static IP: '
prompt2 = 'New Netmask: '
prompt3 = 'DNS 1: '
prompt4 = 'DNS 2: '
prompt5 = 'Hostname: '

#static IP
print "\e[H\e[2J"
puts prompt1
static = gets.chomp 

#netmask
print "\e[H\e[2J"
puts prompt2
netmask = gets.chomp

#dns1
print "\e[H\e[2J"
puts prompt3
dns1 = gets.chomp

#dns2
print "\e[H\e[2J"
puts prompt4
dns2 = gets.chomp

#hostname
print "\e[H\e[2J"
puts prompt5
hostname = gets.chomp

out_file = File.new("/etc/sysconfig/network-scripts/ifcfg-enp0s3", "r+")
out_file.puts(
'BOOTPROTO=static',
'IPADDR=', static, 
'NETMASK=',netmask,
'dns1=', dns1,
'dns2=', dns2,
'hostname=', hostname,
'ONBOOT=yes')

out_file.close

puts IO.read("/etc/sysconfig/network-scripts/ifcfg-enp0s3")
 puts 'Is this information correct? (ctrl+c to close or "n" to retry)'
while yorn = gets.chomp
case yorn
#no
when 'n'
 puts "\e[H\e[2J"
 #retrying
 7.times do |i|
	print "Retrying." + ("." * (i % 3)) + " \r"
	$stdout.flush
	sleep(0.5)
 end
 system("ruby /etc/chef/staticip.rb")
puts "\e[H\e[2J"

system("ruby usrinput.rb")
#if not n or ctrl+c
else
puts "\e[H\e[2J"
puts 'Please enter n to retry or press ctrl+c to exit. '
end
end

#changes the ipaddress in the activemq.sh file for installation later in this script
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

        file_edit('/etc/chef/activemq.sh', '192.168.5.242', + static)
