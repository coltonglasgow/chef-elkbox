#prompts
prompt1 = 'New Static IP: '
prompt2 = 'New Netmask: '
prompt3 = 'DNS 1: (or type "c" and press ENTER to skip) '
prompt4 = 'DNS 2: (or type "c" and press ENTER to skip) '
prompt5 = 'Hostname: '

#static IP
print "\e[H\e[2J"
puts prompt1
while true
	static = gets.chomp 
	if	static =~ /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/
		break
	else	
		puts "\e[H\e[2J"
		puts "invalid response. (ex:192.168.1.50)"
		print prompt1
		print "\n"
	end
end

#netmask
print "\e[H\e[2J"
puts prompt2
while true
	netmask = gets.chomp 
	if	netmask =~ /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/
		break
	else	
		puts "\e[H\e[2J"
		puts "invalid response. (ex:255.255.255.0)"
		print prompt2
		print "\n"
	end
end

#dns1
print "\e[H\e[2J"
puts prompt3
while true
	dns1 = gets.chomp 
	if	dns1 =~ /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/ 
		break
	elsif 'c'
		break
	else	
		puts "\e[H\e[2J"
		puts "invalid response."
		print prompt3
		print "\n"
	end
	end

#dns2
print "\e[H\e[2J"
puts prompt4
while true
	dns2 = gets.chomp 
	if	dns2 =~ /^([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])\.([01]?\d\d?|2[0-4]\d|25[0-5])$/
		break
	elsif 'c'
		break
	else	
		puts "\e[H\e[2J"
		puts "invalid response."
		print prompt4
		print "\n"
	end
end

#hostname
print "\e[H\e[2J"
puts prompt5
while true
	hostname = gets.chomp
	break
end

#write to file
out_file = File.new("/etc/sysconfig/network-scripts/ifcfg-enp0s3", "r+")
out_file.puts(
'BOOTPROTO=static',
'IPADDR=' + static, 
'NETMASK=' + netmask,
'dns1=' + dns1,
'dns2=' + dns2,
'hostname=' + hostname,)

out_file.close

puts IO.read("/etc/sysconfig/network-scripts/ifcfg-enp0s3") 
puts 'Is this information correct? (ctrl+c to close or "n" to retry)'

#file acceptance
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

       file_edit('/etc/chef/activemq.sh', '192.168.5.242' + static)
       
