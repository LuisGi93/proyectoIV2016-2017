require "resolv-replace.rb"

role :yoquese, "yoquese"


namespace :queveobot do
  desc "Iniciamos la aplicacion"

  task :daemon_start do
	on "ubuntu@hostalgo.compute.amazonaws.com" do
		execute  'source ~/.rvm/scripts/rvm && export TOKEN="" && export "TOKEN_TASTEKID="  && export POSTGRES_DATABASE="" && ruby proyectoIV2016-2017/bin/run_as_daemon.rb start'
	end
  end
  
  desc "Paramos la aplicacion"  
  task :daemon_stop do
	on "ubuntu@hostalgo.compute.amazonaws.com" do
		execute  'pkill ruby'
	end
  end
end


