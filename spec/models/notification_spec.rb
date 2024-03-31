require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'scope' do
    let!(:recent_unread_notification) { create(:notification, created_at: 1.month.ago) }
    let!(:recent_read_notification) { create(:notification, :read, created_at: 1.month.ago) }
    let!(:old_unread_notification) { create(:notification, created_at: 4.months.ago) }

    context 'recent' do
      it '3ヶ月以内の通知を取得できる' do
        expect(Notification.recent).to include(recent_unread_notification, recent_read_notification)
        expect(Notification.recent).not_to include(old_unread_notification)
      end
    end

    context 'recent_unread' do
      it '3ヶ月以内かつ未読の通知を取得できる' do
        expect(Notification.recent_unread).to include(recent_unread_notification)
        expect(Notification.recent_unread).not_to include(recent_read_notification, old_unread_notification)
      end
    end
  end
end
