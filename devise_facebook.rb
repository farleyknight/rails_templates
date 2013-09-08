require 'open-uri'

gem "devise"
gem "omniauth"
gem "omniauth-facebook"

run "bundle install"

generate "devise:install"
generate "devise", "User"
generate "devise:views"

# TODO: Move this to a separate file

files = {
  controller: "url_for_omniauth_controller"
}

file "app/controllers/users/omniauth_callbacks_controller.rb", open(files[:controller]).read

insert_into_file "config/initializers/devise.rb", "\n  config.omniauth :facebook, 'APP_ID', 'APP_SECRET'", before: "\nend"

rake "db:migrate"

gsub_file "config/routes.rb", "devise_for :users", 'devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }'
