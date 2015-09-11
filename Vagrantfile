require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
configs     = YAML.load_file("#{current_dir}/config.yaml")
yaml_config = configs['config']

Vagrant.configure(2) do |config|
    ####################
    # Virtual Machine
    ####################
    config.vm.box = "#{yaml_config['box']}"
    config.vm.box_url = "#{yaml_config['box_url']}"

    config.vm.define "#{yaml_config['hostname']}" do |node|
        node.vm.hostname = "#{yaml_config['hostname']}"
    end

    if yaml_config['network']['private_network'].to_s != ''
        config.vm.network 'private_network', ip: "#{yaml_config['network']['private_network']}"
    end

    if yaml_config['network']['public_network'].to_s != ''
        config.vm.network 'public_network'
        if yaml_config['network']['public_network'].to_s != '1'
            config.vm.network 'public_network', ip: "#{yaml_config['network']['public_network']}"
        end
    end

    yaml_config['network']['forwarded_port'].each do |i, port|
        if port['guest'] != '' && port['host'] != ''
            config.vm.network :forwarded_port, guest: port['guest'].to_i, host: port['host'].to_i, auto_correct: true
        end
    end

    ####################
    # PHP
    ####################
    php_modules = "#{yaml_config['php']['modules'].join(' ')}"

    config.vm.provision "shell", run: "once" do |s|
        s.name = "PHP Install"
        s.path = "#{current_dir}/build/php/install.sh"
        s.args = "#{yaml_config['php']['version']} #{php_modules}"
    end

    config.vm.provision "shell", run: "always" do |s|
        s.name = "PHP Configure"
        s.path = "#{current_dir}/build/php/configure.sh"
    end

    ####################
    # Apache Server
    ####################
    apache_modules = "#{yaml_config['apache']['modules'].join(' ')}"

    config.vm.provision "shell", run: "once" do |s|
        s.name = "Apache Install"
        s.path = "#{current_dir}/build/apache/install.sh"
        s.args = "#{apache_modules}"
    end

    config.vm.provision "shell", run: "always" do |s|
        s.name = "Apache Configure"
        s.path = "#{current_dir}/build/apache/configure.sh"
    end

    ####################
    # MySQL
    ####################
    config.vm.provision "shell", run: "once" do |s|
        s.name = "MySQL Install"
        s.path = "#{current_dir}/build/mysql/install.sh"
        s.args = "#{apache_modules}"
    end

    sql_files = "#{yaml_config['mysql']['sql_file'].join(' ')}"
    
    config.vm.provision "shell", run: "always" do |s|
        s.name = "MySQL Configure"
        s.path = "#{current_dir}/build/mysql/configure.sh"
        s.args = "#{yaml_config['mysql']['user']} #{yaml_config['mysql']['pass']} #{sql_files}"
    end

    ####################
    # Tools
    ####################
    yaml_config['tool'].each do |tool|
        config.vm.provision "shell", run: "always" do |s|
            s.name = "#{tool} Configure"
            s.path = "#{current_dir}/build/tool/#{tool}.sh"
        end
    end

    ####################
    # Hostmanager
    ####################

    if Vagrant.has_plugin?('vagrant-hostmanager')
        config.hostmanager.enabled              = true
        config.hostmanager.manage_host          = true
        config.hostmanager.ignore_private_ip    = true
        config.hostmanager.include_offline      = true
    end
end