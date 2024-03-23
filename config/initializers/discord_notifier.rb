Discord::Notifier.setup do |config|
  config.url = ENV['DISCORD_WEBHOOK_URL']
  config.username = '通知bot'
  config.avatar_url = 'https://gyazo.com/be06d2f9206b7c11040a7999369ad049'
  config.wait = true
end
