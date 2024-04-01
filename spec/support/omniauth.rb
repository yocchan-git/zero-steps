# frozen_string_literal: true

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new({
                                                               uid: '123545',
                                                               info: { name: 'yocchan', image: 'https://cdn.discordapp.example/avatars/1111/aaaa' }
                                                             })
