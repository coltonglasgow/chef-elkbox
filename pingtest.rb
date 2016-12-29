puts "\e[H\e[2J"
5.times do |i|
		print "Testing Connection." + ("." * (i % 3)) + " \r"
		$stdout.flush
		sleep(0.5)
end

system('ping localhost -c 3 > /etc/chef/staticiplog.txt')
system('ping google.com -c 3 > /etc/chef/staticipgooglog.txt')

File.open '/etc/chef/staticipgooglog.txt' do |file|
	if file.find { |line| line =~ /3 received/ }
	puts "\e[H\e[2J"
	puts 'Successfuly reached google.com.'
	else 
	puts 'Could not reach google.com.'
	end
	end
	
File.open '/etc/chef/staticiplog.txt' do |file|
	if file.find { |line| line =~ /3 received/ }
	puts 'Successfuly reached localhost.' 
	else 
	puts "\e[H\e[2J"
	puts 'Cannot ping localhost. Press "r" to retry'
	while ans = gets.chomp
	case ans
	#r
	when 'r'
	puts "\e[H\e[2J"
		#retrying
		7.times do |i|
		print "Retrying." + ("." * (i % 3)) + " \r"
		$stdout.flush
		sleep(0.5)
		end
		system("ruby /etc/chef/staticip.rb")

system('rm /etc/chef/staticiplog.txt')
system('rm /etc/chef/staticipgooglog.txt')
end
end
end
end
