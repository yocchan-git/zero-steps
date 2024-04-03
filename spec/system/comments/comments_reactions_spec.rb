# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comments::Reactions' do
  before { login(user) }

  let(:user) { create(:user) }
  let!(:comment) { create(:comment, user: other_user, commentable:) }
  let(:other_user) { create(:user) }
  let(:commentable) { create(:goal) }

  describe '#create' do
    context '目標' do
      context '詳細画面' do
        it 'いいねができること' do
          visit goal_path(commentable)
          within "#comment_reaction_form#{comment.id}" do
            find('.btn').click
            expect(page).to have_css '.fa-solid'
          end
        end
      end
  
      context 'コメント一覧画面' do
        it 'いいねができること' do
          visit goal_comments_path(commentable)
          within "#comment_reaction_form#{comment.id}" do
            find('.btn').click
            expect(page).to have_css '.fa-solid'
          end
        end
      end
    end

    context 'タスク' do
      let(:commentable) { create(:task) }
      context '詳細画面' do
        it 'いいねができること' do
          visit goal_task_path(commentable, goal_id: commentable.goal.id)
          within "#comment_reaction_form#{comment.id}" do
            find('.btn').click
            expect(page).to have_css '.fa-solid'
          end
        end
      end
  
      context 'コメント一覧画面' do
        it 'いいねができること' do
          visit task_comments_path(commentable)
          within "#comment_reaction_form#{comment.id}" do
            find('.btn').click
            expect(page).to have_css '.fa-solid'
          end
        end
      end
    end

    context 'ユーザー詳細画面' do
      it 'いいねができること' do
        visit user_path(other_user)
        within "#comment_reaction_form#{comment.id}" do
            find('.btn').click
            expect(page).to have_css '.fa-solid'
          end
      end
    end
  end
end
