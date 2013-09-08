gem "devise"
gem "omniauth"
gem "omniauth-facebook"

run "bundle install"

generate "devise:install"
generate "devise", "User"
generate "devise:views", "User"

# TODO: Move this to a separate file

file "app/controllers/users/omniauth_callbacks_controller.rb", <<-CODE
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
CODE

insert_into_file "config/initializers/devise.rb", "\n  config.omniauth :facebook, 'APP_ID', 'APP_SECRET'", before: "\nend"

rake "db:migrate"

gsub_file "config/routes.rb", "devise_for :users", 'devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }'
