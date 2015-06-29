Vagrant.configure(2) do |config|
    config.vm.box = "chef/centos-6.6"
    config.vm.box_url = "https://atlas.hashicorp.com/chef/centos-6.6"
    config.vm.network "public_network"
    config.vm.network :forwarded_port, guest:80, host:80
    config.vm.provision :hostmanager
    config.vm.provision :shell, :path => "build/provision.sh"

    if Vagrant.has_plugin?('vagrant-hostmanager')
        config.hostmanager.enabled              = true
        config.hostmanager.manage_host          = true
        config.hostmanager.ignore_private_ip    = true
        config.hostmanager.include_offline      = true
        config.vm.define 'project.dev' do |node|
            node.hostmanager.aliases = %w(www.project.dev)
        end
    end
end