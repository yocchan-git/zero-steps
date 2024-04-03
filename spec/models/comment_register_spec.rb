require 'rails_helper'

RSpec.describe CommentRegister, type: :model do
  let(:comment_register) { described_class.new(commentable, user, params) }

  describe '#execute' do
    subject { comment_register.execute }

    before { allow(Discordrb::API::Channel).to receive(:create_message).and_return('Discordに通知しました') }

    let(:user) { create(:user) }
    let(:commentable) { create(:goal) }
    let(:params) { { content: } }
    let(:content) { 'その目標いいですね' }

    it 'コメントが作成できること' do
      expect { subject }.to change { Comment.count }.by(1)
    end

    context 'メンションがない場合' do
      context '目標の作成者とコメントした人が違う場合' do
        it '通知とタイムラインが作成される' do
          expect { subject }.to change { Timeline.count }.by(1).and change { Notification.count }.by(1)
        end
      end

      context '目標の作成者とコメントした人が同じ場合' do
        let(:commentable) { create(:goal, user:) }

        it 'タイムラインが作成される' do
          expect { subject }.to change { Timeline.count }.by(1).and change { Notification.count }.by(0)
        end
      end
    end

    context 'メンションがあった場合' do
      let(:content) { "@#{user.name} さん、応援しています" }

      context 'メンション相手が目標の作成者の場合' do
        let(:commentable) { create(:goal, user:) }

        it '通知が1つだけ作成される(重複しない)' do
          expect { subject }.to change { Notification.count }.by(1)
        end
      end

      context 'メンション相手が目標の作成者でない場合' do
        it '通知が2つ作成される(メンション相手と目標のオーナー)' do
          expect { subject }.to change { Notification.count }.by(2)
        end
      end
    end
  end
end
