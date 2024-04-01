# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reactions' do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#destroy' do
    context 'コメントの場合' do
      let(:goal) { create(:goal) }
      let!(:comment) { create(:comment, commentable: goal) }
      let!(:reaction) { create(:reaction, :comment, user:, reactionable: comment) }

      it 'いいねを削除できる' do
        visit goal_path(goal)
        within "#comment_reaction_form#{comment.id}" do
          find('.btn').click
          expect(page).to have_css '.fa-regular'
        end
      end
    end

    context '終了投稿の場合' do
      let(:goal) { create(:goal, :completed) }
      let!(:complete_post) { create(:complete_post, complete_postable: goal) }
      let!(:reaction) { create(:reaction, :complete_post, user:, reactionable: complete_post) }

      it 'いいねを削除できる' do
        visit goal_path(goal)
        within "#complete_post_reaction_form#{complete_post.id}" do
          find('.btn').click
          expect(page).to have_css '.fa-regular'
        end
      end
    end
  end
end
