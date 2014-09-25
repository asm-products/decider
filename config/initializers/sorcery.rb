Rails.application.config.sorcery.submodules = []

Rails.application.config.sorcery.configure do |config|
  config.not_authenticated_action = :not_authenticated

  config.user_config do |user|

  end
  config.user_class = "User"
end
