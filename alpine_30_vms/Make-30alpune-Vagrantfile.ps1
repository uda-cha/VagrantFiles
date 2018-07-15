$Header =  @"
Vagrant.configure("2") do |config|
 
  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "128"
  end
   
  config.vm.box = "maier/alpine-3.1.3-x86_64"
  config.vm.synced_folder ".", "/vagrant", disabled: true
 
"@
 
for ($i=1; $i -lt 31; $i++){
$fourthoctet=200 + ${i}
$Body += @"
  config.vm.define "vm${i}" do |vm${i}|
    vm${i}.vm.host_name = "alpinevm${i}"
    vm${i}.vm.network "public_network",
      ip: "192.168.100.${fourthocte}",
      netmask: "255.255.255.0"
  end

"@
}
 
$END = "end"

Add-Content -path .\vagrantfile -value ( $Header + $Body + $END ) -encoding String
