# -*- mode: ruby -*-
# vi: set ft=ruby :

$reboot = "shutdown -r now"

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell",
    run: "always",
    inline: "sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config"
  config.vm.provision "shell",
    run: "always",
    inline: "echo 'KEYMAP=jp106' | sudo tee /etc/vconsole.conf"

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
