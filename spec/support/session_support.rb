# frozen_string_literal: true

module SessionSupport
  def login(user)
    OmniAuth.config.add_mock(:discord, { uid: user.uid, info: { name: user.name, image: user.image } })

    visit new_users_session_path
    click_on 'Discord アカウントでログイン'
  end
end
