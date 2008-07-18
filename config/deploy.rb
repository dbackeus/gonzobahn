set :application, "gonzobahn"

set :host, "sf.eframe.se"

set :deploy_to, "/home/deploy/apps/#{application}"

ssh_options[:port] = 8888

set :use_sudo, false

default_run_options[:pty] = true

set :repository, "git://github.com/druiden/gonzobahn.git"
set :scm, "git"
set :user, "deploy"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

role :production, host

# ===========================================================================
# Monit
# ===========================================================================  

namespace :monit do
  
  desc "Restart Monit"
  task :restart do
    sudo "/etc/init.d/monit restart"
  end
  
  desc "Overwrite monit configs and restart"
  task :update_config do
    sudo "cp #{current_path}/config/monit/*.monitrc /etc/monit/"
    sudo "cp #{current_path}/config/monit/monitrc /etc/"
    sudo "chmod 700 /etc/monitrc"
    sudo "chmod 700 /etc/monit/*"
    restart
  end
  
end

# ===========================================================================
# Database
# ===========================================================================

namespace :db do
	
	task :migrate do
		run "cd #{current_path} && rake db:migrate"
	end
	
end

# ===========================================================================
# Mongrel
# ===========================================================================

namespace :mongrel do
  
  def mongrel_cluster(command)
    "cd #{current_path} && " +
    "mongrel_rails cluster::#{command} -C #{current_path}/config/mongrel_cluster.yml"
  end

  %w(restart stop start).each do |command|
    task command.to_sym do
      run mongrel_cluster(command)
    end
  end
  
end

# ===========================================================================
# Nginx
# ===========================================================================  

namespace :nginx do
  
  desc "Restart Nginx web server"
  task :restart do
    sudo "/etc/rc.d/nginx restart"
  end
  
  desc "Overwrite nginx.conf and restart"
  task :update_config do
    sudo "cp #{current_path}/config/nginx.conf /etc/nginx/nginx.conf"
    restart
  end
  
end

# ===========================================================================
# Deployment hooks
# ===========================================================================

namespace :deploy do
	
	desc "Restart mongrel cluster"
	task :restart do
  	mongrel.restart
	end
	
	desc "Symlink uploads directory"
	task :after_update_code do
	end
	
  desc "Copy or link in server specific configuration files"
  task :setup_config do
    run <<-CMD
    cp #{release_path}/config/database.yml.example #{release_path}/config/database.yml
    CMD
  end

  desc "Run pre-symlink tasks" 
  task :before_symlink do
    setup_config
    db.migrate
  end
  
  desc "Clear out old code trees. Only keep 5 latest releases around"
  task :after_deploy do
    cleanup
  end
  
end