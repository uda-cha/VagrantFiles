# -*- mode: ruby -*-
# vi: set ft=ruby :

$script_kb_CUI = <<SCRIPT
cat << "EOS" | sudo tee "/etc/default/console-setup"
KEYTABLE="jp106"
MODEL="jp106"
LAYOUT="jp"
KEYBOARDTYPE="pc"
EOS
SCRIPT

$script_kb_GUI = <<SCRIPT
cat << "EOS" | sudo tee "/etc/default/keyboard"
XKBMODEL="pc105"
XKBLAYOUT="jp,jp"
XKBVARIANT=""
XKBOPTIONS=""

BACKSPACE="guess"
EOS
SCRIPT

$reboot = "shutdown -r now"

Vagrant.configure("2") do |config|
  config.vm.box = "cxtlabs/vagrant-ubuntu-16.04-mate"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.provision "shell",
    run: "always",
    inline: $script_kb_CUI
  config.vm.provision "shell",
    run: "always",
    inline: $script_kb_GUI

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
