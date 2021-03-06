# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<SCRIPT
cat << "EOS" | sudo tee "/etc/sysconfig/keyboard"
KEYTABLE="jp106"
MODEL="jp106"
LAYOUT="jp"
KEYBOARDTYPE="pc"
EOS
SCRIPT

$reboot = "shutdown -r now"

Vagrant.configure("2") do |config|
  config.vm.box = "centos/6"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell",
    run: "always",
    inline: "sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config"
  config.vm.provision "shell",
    run: "always",
    inline: $script

  @allhosts.each do |host, parameter|
    config.vm.define host.to_s do |h|
      config.vm.provider "virtualbox" do |vb|
        vb.gui = parameter[:gui]
        vb.memory = parameter[:memory]
        vb.cpus = parameter[:cpus]
      end

      h.vm.host_name = parameter[:hostname]
      h.vm.network parameter[:network_type],
        ip:        parameter[:ip],
        netmask:   parameter[:netmask]
      
      parameter[:command].each do |c|
        h.vm.provision "shell",
          run: "always",
          inline: c
      end

      h.vm.provision "shell",
        run: "always",
        inline: $reboot
    end
  end
end
