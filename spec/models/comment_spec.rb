# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  include Rails.application.routes.url_helpers

  describe '#goal?' do
    context '目標のコメントの場合' do
      let(:goal_comment) { create(:comment) }

      it 'trueが返る' do
        expect(goal_comment).to be_goal
      end
    end

    context 'タスクのコメントの場合' do
      let(:task_comment) { create(:comment, :task) }

      it 'falseが返る' do
        expect(task_comment).not_to be_goal
      end
    end
  end

  describe '#formatted_content' do
    let(:comment) { create(:comment, content:) }

    context '内容が20文字の場合' do
      let(:content) { 'a' * 20 }

      it 'そのまま表示される' do
        expect(comment.formatted_content).to eq content
      end
    end

    context '内容が21文字の場合' do
      let(:content) { 'a' * 21 }

      it '「20文字分+...」で表示される' do
        expect(comment.formatted_content).to eq "#{'a' * 20}..."
      end
    end
  end

  describe '#create_mention_notification' do
    let(:comment) { create(:comment, content: "@#{user.name} さん、こんにちは") }

    context '存在するユーザーへメンションした場合' do
      let(:user) { create(:user) }

      it '通知が送られる' do
        allow_any_instance_of(Comment).to receive(:send_message_to_discord)
        expect { comment.create_mention_notification }.to change(Notification, :count).by(1)
      end
    end

    context '存在しないユーザーへメンションした場合' do
      let(:user) { build(:user) }

      it '通知が送られない' do
        expect { comment.create_mention_notification }.not_to(change(Notification, :count))
      end
    end
  end

  describe '#mention_other_than_commentable_user?' do
    let(:comment) { create(:comment, commentable: goal, content:) }
    let(:goal) { create(:goal) }

    context '目標の作成者にメンションしていない場合' do
      let(:content) { "@#{user.name} さん、こんにちは" }
      let(:user) { create(:user) }

      it 'trueが返る' do
        expect(comment).to be_mention_other_than_commentable_user
      end
    end

    context '目標の作成者にメンションした場合' do
      let(:content) { "@#{goal.user.name} さん、こんにちは" }

      it 'falseが返る' do
        expect(comment).not_to be_mention_other_than_commentable_user
      end
    end
  end

  describe '#comment_url' do
    context '目標のコメントの場合' do
      let(:goal_comment) { create(:comment) }

      it 'コメント一覧(目標)のURLが返る' do
        expect(goal_comment.comment_url).to eq goal_comments_url(goal_comment.commentable)
      end
    end

    context 'タスクのコメントの場合' do
      let(:task_comment) { create(:comment, :task) }

      it 'コメント一覧(タスク)のURLが返る' do
        expect(task_comment.comment_url).to eq task_comments_url(task_comment.commentable)
      end
    end
  end

  describe '#send_message_to_discord' do
    before do
      allow(Discordrb::API::Channel).to receive(:create_message).and_return('Discordに通知しました')
    end

    let(:comment) { create(:comment) }

    it 'Discordに通知ができる' do
      expect(comment.send_message_to_discord(:comment)).to eq 'Discordに通知しました'
      expect(Discordrb::API::Channel).to have_received(:create_message).once.with(
        "Bot #{ENV.fetch('DISCORD_BOT_TOKEN', nil)}",
        ENV.fetch('DISCORD_CHANNEL_ID', nil),
        "<@#{comment.commentable.user.uid}>さん\n\n#{comment.commentable.formatted_title}に#{comment.user.name}さんからコメントがありました\n\nコメント本文\n「#{comment.formatted_content}」\n\n[詳細はこちら](#{comment.comment_url})"
      )
    end
  end
end
