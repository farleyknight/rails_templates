
Devise.setup do |config|
  FacebookConfig = YAML.load_file("config/facebook.yml")
  config.omniauth :facebook, FacebookConfig[:app_id], FacebookConfig[:app_secret]
end

