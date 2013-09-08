require 'optparse'
require 'open-uri'

options = {
  app_id:     "my_app_id",
  app_secret: "my_app_secret"
}

OptionParser.new do |opts|
  opts.on("-m", "--script SCRIPT", "Rails template script") do |script|
    options[:script]     = script
  end

  opts.on("-a", "--app_id APP_ID", "Facebook App ID") do |id|
    options[:app_id]     = id
  end

  opts.on("-s", "--app_secret APP_SECRET", "Facebook App Secret") do |secret|
    options[:app_secret] = secret
  end
end.parse!


REPO_URL = "https://raw.github.com/farleyknight/rails_templates/master"

FILES = {
  controller:  "devise_facebook/omniauth_controller.rb",
  initializer: "devise_facebook/initializer.rb",
  config:      "devise_facebook/facebook.yml",
  user:        "devise_facebook/user.rb"
}


def using_remote_recipe?
  options[:script] =~ /http/
end

def open_file(file_id)
  path = FILES[file_id]

  if using_remote_recipe?
    open("#{REPO_URL}/#{path}").read
  else
    full_path = File.join(File.dirname(__FILE__), path)
    File.read(full_path)
  end
end

def replace(string, patterns)
  patterns.each do |key, value|
    string.gsub!(key, value)
  end
  string
end

gem "devise"
gem "omniauth"
gem "omniauth-facebook"

run "bundle install"

generate "devise:install"
generate "devise", "User"
generate "devise:views"

gsub_file "config/routes.rb", "devise_for :users", 'devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }'

generate "migration", "AddUidToUsers", "provider:string", "uid:string", "name:string"

file "app/controllers/users/omniauth_callbacks_controller.rb", open_file(:controller)
file "config/initializers/devise_facebook.rb",                 open_file(:initializer)
file "app/models/user.rb",                                     open_file(:user), :force => true
file "config/facebook.yml",                                    replace(open_file(:config), "[APP_ID]" => options[:app_id], "[APP_SECRET]" => options[:app_secret])

rake "db:migrate"
