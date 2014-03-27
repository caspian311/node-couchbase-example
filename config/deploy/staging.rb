# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{vagrant@node}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server 'node', user: 'deploy', roles: %w{web app}

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

   desc "Check that we can access everything"
   task :check_write_permissions do
      on roles(:all) do |host|
         if test("[ -w #{fetch(:deploy_to)} ]")
            info "#{fetch(:deploy_to)} is writable on #{host}"
         else
            error "#{fetch(:deploy_to)} is not writable on #{host}"
         end
      end
   end

   namespace :deploy do
      desc "Install npm"
      task :install_npm do
         on roles(:all) do |host|
            execute "cd #{current_path} && npm install"
         end
      end

      desc "Run node"
      task :run_node do
         on roles(:all) do |host|
            execute <<EOC
            ( cd #{current_path}
               node app &> /var/log/node/output.log & echo $! > /var/tmp/node.pid )
EOC
         end
      end

      desc "Stop node"
      task :stop_node do
         on roles(:all) do |host|
            execute "kill $(cat /var/tmp/node.pid) && rm -f /var/tmp/node.pid"
         end
      end
   end
