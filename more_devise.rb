

gem "devise"

generate "devise:install"
generate "devise", "User"

rake "db:migrate"

generate "devise:views", "User"

