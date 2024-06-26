# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :discord, ENV.fetch('DISCORD_CLIENT_ID', nil), ENV.fetch('DISCORD_CLIENT_SECRET', nil), scope: 'identify'

  OmniAuth.config.on_failure = proc { |_env| [302, { 'Location' => '/auth/failure', 'Content-Type' => 'text/html' }, []] }
end
