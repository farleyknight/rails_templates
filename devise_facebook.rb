

gem "devise"
gem "omniauth"
gem "omniauth-facebook"

generate "devise:install"
generate "devise", "User"

rake "db:migrate"

generate "devise:views", "User"

