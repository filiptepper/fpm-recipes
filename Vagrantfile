Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: <<-SHELL
    cd /vagrant
    sudo apt-get install -y ruby-dev
    sudo gem install fpm-cookery
  SHELL
end
