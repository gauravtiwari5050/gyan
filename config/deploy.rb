require "bundler/capistrano"

set :application, "gauravtiwari.net"
set :repository, "git://github.com/gauravtiwari5050/gyan.git"

set :scm, "git"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :app, application
role :web, application
role :db,  application, :primary => true

set :user, "cchq"
set :use_sudo, false
set :deploy_to, "/home/cchq/gyan"
ssh_options[:auth_methods] = "publickey"
# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
   task :copy_database_configuration do
     production_db_config = "/home/cchq/production.gyan.database.yml"
     production_mail_config = "/home/cchq/production.gyan.setup_mail.rb"
     run "cp #{production_db_config} #{release_path}/config/database.yml"
     run "cp #{production_mail_config} #{release_path}/config/initializers/setup_mail.rb"
   end

   after "deploy:update_code" , "deploy:copy_database_configuration" ,"delayed_job:restart"
 end
 namespace :delayed_job do 
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do
        run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
    end
 end

