module SessionSupport
  def login(user)
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.add_mock(:discord, {uid: user.uid, info: { name: user.name, image: user.image }})
    visit new_users_session_path
    click_button 'Discord アカウントでログイン'
  end
end
