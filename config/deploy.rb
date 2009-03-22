set :application, "gonzobahn"

set :host, "79.99.2.126"
set :user, "deploy"
ssh_options[:port] = 8888

set :deploy_to, "/home/deploy/apps/#{application}"

set :repository, "git://github.com/dbackeus/gonzobahn.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :git_shallow_clone, 1

role :production, host

set :use_sudo, false
default_run_options[:pty] = true

# ===========================================================================
# Deployment hooks
# ===========================================================================

namespace :deploy do
	
	desc "Restart mongrel cluster"
	task :restart do
  	run "touch #{current_path}/tmp/restart.txt"
	end
	
	desc "Symlink uploads directory"
	task :after_update_code do
	end
	
  desc "Copy or link in server specific configuration files"
  task :setup_config do
    run <<-CMD
    cp #{release_path}/config/database.yml.example #{release_path}/config/database.yml &&
    ln -s #{shared_path}/config/directories.rb #{current_path}/config/initializers/directories.rb
    CMD
  end

  desc "Run pre-symlink tasks" 
  task :after_symlink do
    setup_config
    #migrate
  end
  
  desc "Clear out old code trees. Only keep 5 latest releases around"
  task :after_deploy do
    cleanup
  end
  
end