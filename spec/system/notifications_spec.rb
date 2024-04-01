require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  before { login(user) }
  let(:user) { create(:user) }

  describe '#index' do
    let!(:own_notification) { create(:notification, user:, content: 'メンションがありました') }
    let!(:other_notification) { create(:notification) }

    it '自分の通知が表示されている' do
      visit notifications_path
      expect(page).to have_link own_notification.content
      expect(page).not_to have_link other_notification.content
    end
  end
end
