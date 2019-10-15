# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
cat << "EOS" > /etc/nginx/default.d/myphp.conf
location / {
    root   /usr/share/nginx/html;
    index  index.html index.htm index.php;
}
location ~ \.php$ {
    root           /usr/share/nginx/html;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}
EOS
SCRIPT

@allhosts = {
  vm1: {
    hostname:     "CentOS7vm1",
    ip:           "192.168.56.121",
    netmask:      "255.255.255.0",
    network_type: "private_network",   #or public_network, or forwarded_port
    gui:          false,
    memory:       "768",
    cpus:         "1"
    command: [
        "yum install epel-release -y",
        "yum install nginx php php-fpm vim tree -y",
        "sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config",
        "sed -i -e 's/;default_charset = \"UTF-8\"/default_charset = \"UTF-8\"/g' /etc/php.ini",
        "sed -i -e 's/user = apache/user = nginx/g' /etc/php-fpm.d/www.conf",
        "sed -i -e 's/group = apache/group = nginx/g' /etc/php-fpm.d/www.conf",
        "chown -R nginx:nginx /usr/share/nginx/html",
        "chmod 775 /usr/share/nginx/html",
        "chmod 664 /usr/share/nginx/html/*",
        "gpasswd -a vagrant nginx",
        "gpasswd -a nginx vagrant",
        "sed -i -e 'N;s/^\\s*\\slocation \\/ {.*}//' /etc/nginx/nginx.conf",
        $script,
        "systemctl enable nginx php-fpm",
    ],
  },
}

load "./Vagrantfile.common" if File.exist?("./Vagrantfile.common.rb")