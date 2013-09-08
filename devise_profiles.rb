require 'open-uri'

REPO_URL = "https://raw.github.com/farleyknight/rails_templates/master"

FILES = {
  controller:  "devise_profiles/omniauth_controller.rb",
  initializer: "devise_profiles/initializer.rb",
  config:      "devise_profiles/facebook.yml",
  user:        "devise_profiles/user.rb"
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


gem "devise"

generate "devise:install"
generate "devise", "User"

generate "model", "Profile", "first_name:string", "last_name:string", "user_id:integer", "location:string"

rake "db:migrate"

