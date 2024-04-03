# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment do
  include Rails.application.routes.url_helpers

  describe '#url' do
    context '目標のコメントの場合' do
      let(:goal_comment) { create(:comment) }

      it 'コメント一覧(目標)のURLが返る' do
        expect(goal_comment.url).to eq goal_comments_url(goal_comment.commentable)
      end
    end

    context 'タスクのコメントの場合' do
      let(:task_comment) { create(:comment, :task) }

      it 'コメント一覧(タスク)のURLが返る' do
        expect(task_comment.url).to eq task_comments_url(task_comment.commentable)
      end
    end
  end
end
