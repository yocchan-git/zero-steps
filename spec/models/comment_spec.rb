# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  include Rails.application.routes.url_helpers

  describe '.create_with_notification_and_timeline' do
    subject { described_class.create!(commentable, user, params) }

    let(:commentable) { create(:goal) }
    let(:user) { create(:user) }
    let(:params) { { content: 'その目標いいですね' } }

    it 'コメントが作成できること' do
      expect { subject }.to change { Comment.count }.by(1)
    end
  end

  describe '#create_notification_and_timeline' do
    subject { comment.create_notification_and_timeline }

    before { allow(Discordrb::API::Channel).to receive(:create_message).and_return('Discordに通知しました') }

    let(:comment) { create(:comment, user:, commentable:, content:) }
    let(:user) { create(:user) }
    let(:commentable) { create(:goal) }
    let(:content) { 'その目標いいですね' }

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
end
