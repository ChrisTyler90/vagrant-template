require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
configs     = YAML.load_file("#{current_dir}/config.yaml")
user_config = configs['config']

case user_config['vagrant']['box']['name']
when /ubuntu/
   os = "debian"
when /centos/
   os = "redhat"
else
    raise Vagrant::Errors::VagrantError.new, "Unidentified OS"
end

Vagrant.configure(2) do |config|
    ####################
    # Virtual Machine
    ####################

    config.vm.box = "#{user_config['vagrant']['box']['name']}"
    config.vm.box_url = "#{user_config['vagrant']['box']['url']}"

    config.vm.provider "virtualbox" do |v|
        v.cpus = "#{user_config['vagrant']['cpus']}"
        v.memory = "#{user_config['vagrant']['memory']}"
    end

    if user_config['vagrant']['network']['private_address'].to_s != ''
        config.vm.network 'private_network', ip: "#{user_config['vagrant']['network']['private_address']}"
    end

    user_config['vagrant']['network']['forwarded_port'].each do |i, port|
        config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i, auto_correct: true
    end

    ####################
    # Server
    ####################

    config.vm.hostname = "#{user_config['server']['hostname']}"

    # Package Manager
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "Package Manager"
        s.path = "#{current_dir}/build/#{os}/package-manager.sh"
    end

    # Packages
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "Packages"
        s.path = "#{current_dir}/build/#{os}/package.sh"
        s.args = "#{user_config['server']['packages'].join(' ')}"
    end

    ####################
    # PHP
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "PHP"
        s.path = "#{current_dir}/build/#{os}/php.sh"
        s.args = "#{user_config['php']['install']} #{user_config['php']['version']} #{user_config['php']['modules'].join(' ')}"
    end

    ####################
    # MySQL
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "MySQL"
        s.path = "#{current_dir}/build/#{os}/mysql.sh"
        s.args = "#{user_config['mysql']['install']} #{user_config['mysql']['version']} #{user_config['mysql']['user']} #{user_config['mysql']['pass']} #{user_config['mysql']['db']} #{user_config['mysql']['import'].join(' ')}"
    end

    ####################
    # Apache
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "Apache"
        s.path = "#{current_dir}/build/#{os}/apache.sh"
        s.args = "#{user_config['apache']['install']} #{user_config['apache']['user']} #{user_config['apache']['web_root']} #{user_config['apache']['log_dir']} #{user_config['apache']['modules'].join(' ')}"
    end

    ####################
    # Adminer
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "Adminer"
        s.path = "#{current_dir}/build/#{os}/adminer.sh"
        s.args = "#{user_config['adminer']['install']}"
    end

    ####################
    # FTP
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "FTP"
        s.path = "#{current_dir}/build/#{os}/ftp.sh"
        s.args = "#{user_config['ftp']['install']}"
    end

    ####################
    # Nano
    ####################

    config.vm.provision "shell", run: "always" do |s|
        s.name = "Nano"
        s.path = "#{current_dir}/build/#{os}/nano.sh"
    end

    ####################
    # Hostmanager
    ####################

    if user_config['vagrant']['network']['hostmanager'].to_s != '0'
        config.hostmanager.enabled           = true
        config.hostmanager.manage_host       = true
        config.hostmanager.ignore_private_ip = true
        config.hostmanager.include_offline   = true
    end
end