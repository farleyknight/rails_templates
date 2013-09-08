require 'open-uri'

FILES = {
  controller: "https://raw.github.com/farleyknight/rails_templates/master/devise_facebook/omniauth_controller.rb"
}

gem "devise"
gem "omniauth"
gem "omniauth-facebook"

run "bundle install"

generate "devise:install"
generate "devise", "User"
generate "devise:views"

file "app/controllers/users/omniauth_callbacks_controller.rb", open(FILES[:controller]).read

insert_into_file "config/initializers/devise.rb", "\n  config.omniauth :facebook, 'APP_ID', 'APP_SECRET'", before: "\nend"

gsub_file "config/routes.rb", "devise_for :users", 'devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }'

rake "db:migrate"
