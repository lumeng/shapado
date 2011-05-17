set :application, "shapado"

task :staging do |t|
  set :repository, "git://github.com/ricodigo/shapado.git"
  set :branch, "origin/next"
  set :rails_env, :production
  set :unicorn_workers, 1
  role :web, "metali.co"
  role :app, "metali.co"
  role :db,  "metali.co", :primary => true
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "cp #{current_path}/config/auth_providers.yml.sample #{current_path}/config/auth_providers.yml"

    run "echo '#{`git describe`}' > #{current_path}/public/version.txt"

    Jammit.package!
    magent.restart
    bluepill.restart
  end
end
require 'jammit'
require 'ricodigo_capistrano_recipes'
