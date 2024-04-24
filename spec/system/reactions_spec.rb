# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reactions' do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#destroy' do
    context 'コメントの場合' do
      before { create(:reaction, user:, reactionable: comment) }

      let(:goal) { create(:goal) }
      let!(:comment) { create(:comment, commentable: goal) }

      it 'いいねを削除できる' do
        visit goal_path(goal, is_comments: true)
        within "#comment_reaction_form#{comment.id}" do
          find('.btn').click
          expect(page).to have_css '.fa-regular'
        end
      end
    end

    context '終了投稿の場合' do
      before { create(:reaction, :complete_post, user:, reactionable: complete_post) }

      let(:goal) { create(:goal, :completed) }
      let!(:complete_post) { create(:complete_post, complete_postable: goal) }

      it 'いいねを削除できる' do
        visit goal_path(goal, is_complete_post: true)
        within "#complete_post_reaction_form#{complete_post.id}" do
          find('.btn').click
          expect(page).to have_css '.fa-regular'
        end
      end
    end
  end
end
