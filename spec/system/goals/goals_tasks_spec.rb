# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Goals::Tasks' do
  before { login(user) }

  let(:user) { create(:user) }
  let(:goal) { create(:goal) }
  let!(:task) { create(:task, goal:) }
  let!(:completed_task) { create(:task, :completed, goal:) }

  describe '#index' do
    it '正しく表示されている' do
      visit goal_tasks_path(goal)
      expect(page).to have_css 'h1', text: "#{formatted_text(goal)}のタスク一覧"
      expect(page).to have_link formatted_text(task)
      expect(page).to have_link formatted_text(completed_task)
    end
  end

  describe '#show' do
    it '正しく表示されている' do
      visit goal_task_path(task, goal_id: goal.id)
      expect(page).to have_link 'タスク一覧へ'
      expect(page).to have_content task.content
      expect(page).to have_css 'h2', text: 'コメント'
    end

    context '終了していないタスクの場合' do
      context '他人のタスクの場合' do
        it '終了投稿ボタンが表示されない' do
          visit goal_task_path(task, goal_id: goal.id)
          expect(page).to have_no_link '終了投稿する'
        end
      end

      context '自分のタスクの場合' do
        let(:task) { create(:task, goal:, user:) }

        it '終了投稿ボタンが表示される' do
          visit goal_task_path(task, goal_id: goal.id)
          expect(page).to have_link '終了する'
        end
      end
    end

    context '終了しているタスクの場合' do
      before { create(:complete_post, :task, complete_postable: completed_task) }

      it '終了投稿が表示される' do
        visit goal_task_path(completed_task, goal_id: goal.id, is_complete_post: true)
        expect(page).to have_css 'h2', text: '終了投稿'
        expect(page).to have_content completed_task.complete_post.content
      end
    end

    context 'コメントがない場合' do
      it 'コメントがない文言が表示される' do
        visit goal_task_path(task, goal_id: goal.id)
        expect(page).to have_content 'コメントがありません'
      end
    end

    context 'コメントがある場合' do
      let!(:comment) { create(:comment, :task, commentable: task) }

      it 'コメントが表示される' do
        visit goal_task_path(task, goal_id: goal.id)
        expect(page).to have_no_content '最近のコメントはありません'
        expect(page).to have_content formatted_text(comment)
      end
    end
  end

  describe '#create' do
    context '目標詳細画面' do
      context 'タスクが存在しない場合' do
        let(:new_goal) { create(:goal, user:) }

        it 'タスクを作成できること' do
          visit goal_path(new_goal)
          within '#taskFormModal' do
            fill_in '内容(500文字以内)', with: '水泳教室に通う'
            fill_in '期限', with: '002024-04-01T00:00'
            click_on '作成する'
          end

          expect(page).to have_link '水泳教室に通う'
        end
      end
    end

    context 'タスク一覧画面' do
      let(:goal) { create(:goal, user:) }

      it 'タスクを作成できること' do
        visit goal_tasks_path(goal)
        within '#taskFormModal' do
          fill_in '内容(500文字以内)', with: '水泳教室に通う'
          fill_in '期限', with: '002024-04-01T00:00'
          click_on '作成する'
        end

        expect(page).to have_link '水泳教室に通う'
      end
    end
  end

  describe '#update' do
    let(:goal) { create(:goal, user:) }
    let!(:own_task) { create(:task, goal:, user:) }

    context 'タスク一覧画面' do
      it 'タスクの更新ができること' do
        visit goal_tasks_path(goal)
        within "#taskFormModal#{own_task.id}" do
          fill_in '内容(500文字以内)', with: '水泳教室に通う'
          fill_in '期限', with: '002024-04-01T00:00'
          click_on '更新する'
        end

        expect(page).to have_link '水泳教室に通う'
      end
    end

    context 'タスク詳細画面' do
      it 'タスクの更新ができること' do
        visit goal_task_path(own_task, goal_id: goal.id)
        within "#taskFormModal#{own_task.id}" do
          fill_in '内容(500文字以内)', with: '水泳教室に通う'
          fill_in '期限', with: '002024-04-01T00:00'
          click_on '更新する'
        end

        expect(page).to have_css 'h1', text: '水泳教室に通う'
      end
    end

    context 'ユーザー詳細画面' do
      it 'タスクの更新ができること' do
        visit user_path(user, is_tasks: true)
        within "#taskFormModal#{own_task.id}" do
          fill_in '内容(500文字以内)', with: '水泳教室に通う'
          fill_in '期限', with: '002024-04-01T00:00'
          click_on '更新する'
        end

        expect(page).to have_link '水泳教室に通う'
      end
    end
  end

  describe '#destroy' do
    let(:goal) { create(:goal, user:) }
    let!(:own_task) { create(:task, goal:, user:, content: '水泳教室に通う') }

    context 'タスク一覧画面' do
      it 'タスクの削除ができること' do
        visit goal_tasks_path(goal)
        within "#taskDeleteModal#{own_task.id}" do
          click_on '削除する'
        end

        expect(page).to have_css '.alert-success', text: 'タスクを削除しました'
        expect(page).to have_no_link '水泳教室に通う'
      end
    end

    context 'タスク詳細画面' do
      it 'タスクの削除ができること' do
        visit goal_task_path(own_task, goal_id: goal.id)
        within "#taskDeleteModal#{own_task.id}" do
          click_on '削除する'
        end

        expect(page).to have_css '.alert-success', text: 'タスクを削除しました'
        expect(page).to have_no_link '水泳教室に通う'
      end
    end

    context 'ユーザー詳細画面' do
      it 'タスクの削除ができること' do
        visit user_path(user, is_tasks: true)
        within "#taskDeleteModal#{own_task.id}" do
          click_on '削除する'
        end

        expect(page).to have_css '.alert-success', text: 'タスクを削除しました'
        expect(page).to have_no_link '水泳教室に通う'
      end
    end
  end
end
