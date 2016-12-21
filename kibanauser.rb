print "\e[H\e[2J"
prompt = 'Please enter a username for the Kibana web interface:'
puts prompt
user_name = gets.chomp

system('htpasswd -c /etc/nginx/htpasswd.users ' + user_name)
