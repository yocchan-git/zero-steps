# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments', :js do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#destroy' do
    let!(:comment) { create(:comment, user:, commentable:) }

    context '目標コメントの場合' do
      let(:commentable) { create(:goal) }

      it '削除できる' do
        visit goal_comments_path(commentable)
        find("#comment-delete-icon#{comment.id}").click
        expect(page.accept_confirm).to eq "#{comment.formatted_content}を本当に削除しますか？"
        expect(page).to have_no_content comment.content
      end
    end

    context 'タスクコメントの場合' do
      let(:commentable) { create(:task) }

      it '削除できる' do
        visit task_comments_path(commentable)
        find("#comment-delete-icon#{comment.id}").click
        expect(page.accept_confirm).to eq "#{comment.formatted_content}を本当に削除しますか？"
        expect(page).to have_no_content comment.content
      end
    end
  end
end
