Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.define "queveobot-aws" do |host|
    host.vm.hostname = "queveobot-aws"
  end
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = "ENV['ACCESS_KEY_ID']"
    aws.secret_access_key = "ENV['SECRET_ACCESS_KEY']"
    aws.session_token = "ENV['SESSION_TOKEN']"
    aws.keypair_name = "millave4"
    aws.region= "us-west-2"
    aws.security_groups = "migruposeguro"
    aws.instance_type= 't2.micro'
   
    aws.ami = "ami-d57dcfb5"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "millave4.pem"
  end
  
    config.vm.provision :ansible do |ansible|
	ansible.playbook = "queveobot.yml"
	ansible.force_remote_user= true
	ansible.host_key_checking=false
  end
end
