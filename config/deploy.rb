require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/puma_systemd'
require 'mina_sidekiq/tasks'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :rails_env, 'production'

set :application_name, 'scrapper'
set :domain, '15.207.195.182'
set :deploy_to, '/home/ubuntu/scrapper'
set :repository, 'git@github.com:suhprod/scrapper.git'
set :branch, 'main'

# Optional settings:
set :user, 'ubuntu'          # Username in the server to SSH to.
set :port, '22'              # SSH port number.
# set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
set :shared_dirs, fetch(:shared_dirs, []).push('public/assets', 'tmp/pids', 'tmp/sockets', 'log')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', '.env')

# For sidekiq/puma systemd service
set :init_system, :systemd
set :puma_systemctl, 'systemctl --user'
# Install service in user directory
# set :service_unit_path, '/home/ubuntu/.config/systemd/user'

# rbenv bundler path
# set :bundler_path, '$HOME/.local/share/mise/shims/bundler'

set :bun_path, '$HOME/.bun'

task :'bun:load' do
  comment %(Loading bun)
  command %(export BUN_ROOT="#{fetch(:bun_path)}")
  command %(export PATH="#{fetch(:bun_path)}/bin:$PATH")
  command %(
    if ! which bun >/dev/null; then
      echo "! bun not found"
      echo "! If bun is installed, check your :bun_path setting."
      exit 1
    fi
  )
end

set :mise_path, '$HOME/.local/share/mise'

task :'mise:load' do
  comment %(Loading mise)
  command %(
    if ! which mise >/dev/null; then
      echo "! mise not found"
      echo "! If mise is installed, check your :mise_path setting."
      exit 1
    fi
  )
  command %{eval "$(mise activate bash --shims)"}
end

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  invoke :'mise:load'
  invoke :'bun:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-3.1.1@default'
end

desc 'Update cron jobs based on enabled sources'
task :update_all_jobs do
  comment %(Creating cron jobs from enabled sources)
  command %(#{fetch(:rake)} update_all_jobs)
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  command %(curl https://mise.jdx.dev/mise-latest-linux-x64 > ~/.local/bin/mise)
  command %(chmod +x ~/.local/bin/mise)
  command %(mise use ruby@3.4.1)
  command %(mise use node@22.12.0)
  command %(mise x ruby@3.4.1 -- gem update --system)

  # Puma/Sidekiq needs a place to store its pid file and socket file.
  command %(mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/sockets")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/sockets")
  command %(mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/pids")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/tmp/pids")
  command %(mkdir -p "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log")
  command %(chmod g+rx,u+rwx "#{fetch(:deploy_to)}/#{fetch(:shared_path)}/log")
end

desc 'Deploys the current version to the server.'
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    # invoke :'sidekiq:quiet'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_create'
    invoke :'rails:db_migrate'
    command %(bun install)
    command %(bun run build)
    invoke :'rails:assets_precompile'
    invoke :'rails:assets_clean'
    invoke :'deploy:cleanup'
    on :launch do
      in_path(fetch(:current_path)) do
        command %(mkdir -p tmp/)
        invoke :'puma:restart'
        invoke :'sidekiq:restart'
        # invoke :update_all_jobs
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
