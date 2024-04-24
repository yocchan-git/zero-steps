# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CompletePosts::Reactions' do
  before { login(user) }

  let(:user) { create(:user) }
  let!(:complete_post) { create(:complete_post, complete_postable:) }

  describe '#create' do
    context '目標詳細' do
      let(:complete_postable) { create(:goal, :completed) }

      it 'いいねができること' do
        visit goal_path(complete_postable, is_complete_post: true)
        within "#complete_post_reaction_form#{complete_post.id}" do
          find('.btn').click
          expect(page).to have_css '.fa-solid'
        end
      end
    end

    context 'タスク詳細' do
      let(:complete_postable) { create(:task, :completed) }

      it 'いいねができること' do
        visit goal_task_path(complete_postable, goal_id: complete_postable.goal.id, is_complete_post: true)
        within "#complete_post_reaction_form#{complete_post.id}" do
          find('.btn').click
          expect(page).to have_css '.fa-solid'
        end
      end
    end
  end
end
