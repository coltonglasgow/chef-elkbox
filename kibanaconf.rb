	#server block
prompt = 'Kibana server name(this should match your server name):'
print "\e[H\e[2J"
puts prompt
srvname = gets.chomp 

out_file = File.new("/etc/nginx/conf.d/kibana.conf", "w")
out_file.puts('server {',
        '	listen 80;',
        '	server_name ' + srvname + ';',
        '	auth_basic "Restricted Access";',
        '	auth_basic_user_file /etc/nginx/htpasswd.users;',

        '	location / {',

                '		proxy_pass http://localhost:5601;',
                '		proxy_http_version 1.1;',
                '		proxy_set_header Upgrade $http_upgrade;',
                '		proxy_set_header Connection "upgrade";',
                '		proxy_set_header Host $host;',
                '		proxy_cache_bypass $http_upgrade;',

        '	}',

'}')

out_file.close
system('exit')
