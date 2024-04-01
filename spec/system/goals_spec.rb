require 'rails_helper'

RSpec.describe "Goals", type: :system do
  before { login(user) }
  let(:user) { create(:user) }

  describe '#index' do
    let!(:goal1) { create(:goal) }
    let!(:goal2) { create(:goal) }

    it 'アクセスできる' do
      visit goals_path
      expect(page).to have_selector 'h1', text: 'みんなの目標'
      expect(page).to have_content goal1.title
      expect(page).to have_content goal2.title
    end
  end

  describe '#show' do
    let(:goal) { create(:goal) }

    context 'タスク・コメントがない場合' do
      it 'タスク・コメントがない場合の文言が表示される' do
        visit goal_path(goal)
        expect(page).to have_content '最近のタスクはありません'
        expect(page).to have_content '最近のタスクはありません'
      end

      context '自分の目標の場合' do
        let(:goal) { create(:goal, user:) }

        it '修正などのボタンが表示される' do
          visit goal_path(goal)
          expect(page).to have_link '終了投稿する'
          expect(page).to have_link '修正する'
          expect(page).to have_button 'タスクを作成する'
        end
      end

      context '他人の目標の場合' do
        it '「タスクを作成する」の文言が表示されない' do
          visit goal_path(goal)
          expect(page).not_to have_link '終了投稿する'
          expect(page).not_to have_link '修正する'
          expect(page).not_to have_button 'タスクを作成する'
        end
      end
    end

    context 'タスクがある場合' do
      let!(:task1) { create(:task, goal:, created_at: Time.current - 1.days) }
      let!(:task2) { create(:task, goal:, created_at: Time.current - 2.days) }
      let!(:task3) { create(:task, goal:, created_at: Time.current - 3.days) }

      context 'タスクが3つ以下の場合' do
        it 'タスクが3つ表示されている' do
          visit goal_path(goal)
          expect(page).to have_link task1.content
          expect(page).to have_link task2.content
          expect(page).to have_link task3.content
        end
      end

      context 'タスクが4つの場合' do
        let!(:new_task) { create(:task, goal:, created_at: Time.current) }

        it '最新のタスクが3つ表示されている' do
          visit goal_path(goal)
          expect(page).to have_link new_task.content
          expect(page).to have_link task1.content
          expect(page).to have_link task2.content
        end
      end
    end

    context 'コメントがある場合' do
      let!(:comment1) { create(:comment, commentable: goal, created_at: Time.current - 1.days) }
      let!(:comment2) { create(:comment, commentable: goal, created_at: Time.current - 2.days) }
      let!(:comment3) { create(:comment, commentable: goal, created_at: Time.current - 3.days) }

      context 'コメントが3つ以下の場合' do
        it 'コメントが3つ表示されている' do
          visit goal_path(goal)
          expect(page).to have_content comment1.content
          expect(page).to have_content comment2.content
          expect(page).to have_content comment3.content
        end
      end

      context 'コメントが4つの場合' do
        let!(:new_comment) { create(:comment, commentable: goal, created_at: Time.current) }

        it '最新のコメントが3つ表示されている' do
          visit goal_path(goal)
          expect(page).to have_content new_comment.content
          expect(page).to have_content comment1.content
          expect(page).to have_content comment2.content
        end
      end
    end
  end

  describe '#new' do
    it 'アクセスできる' do
      visit new_goal_path
      expect(page).to have_selector 'h1', text: '目標を作成する'
    end
  end

  describe '#edit' do
    let(:goal) { create(:goal, user:) }

    it 'アクセスできる' do
      visit edit_goal_path(goal)
      expect(page).to have_selector 'h1', text: '目標を編集する'
      expect(page).to have_field 'タイトル(250文字以内)', with: goal.title
      expect(page).to have_field '説明(500文字以内)', with: goal.description
    end
  end

  describe '#create' do
    context 'フォームに不正な値を入力した場合' do
      context 'titleが空の場合' do
        it '送信できないこと' do
          visit new_goal_path
          click_button '作成する'
          expect(page).to have_selector 'h1', text: '目標を作成する'
        end
      end

      context 'titleに251文字以上入っている場合' do
        it '250文字までしか入力できないこと' do
          visit new_goal_path
          fill_in 'タイトル(250文字以内)', with: 'あ' * 251
          fill_in '説明(500文字以内)', with: '毎日継続します！'
          click_button '作成する'
          expect(page).to have_selector 'h2', text: 'あ' * 250
        end
      end
    end

    context 'フォームに正常な値を入力した場合' do
      it '目標を作成できる' do
        visit new_goal_path
        fill_in 'タイトル(250文字以内)', with: '体重を50kgにする'
        fill_in '説明(500文字以内)', with: '毎日継続します！'
        click_button '作成する'
        expect(page).to have_selector 'h2', text: '体重を50kgにする'
      end
    end
  end

  describe '#update' do
    let(:goal) { create(:goal, user:) }

    context 'フォームに不正な値を入力した場合' do
      context 'titleが空の場合' do
        it 'エラーの文言が表示される' do
          visit edit_goal_path(goal)
          fill_in 'タイトル(250文字以内)', with: ''
          click_button '更新する'
          expect(page).to have_selector 'h1', text: '目標を編集する'
        end
      end

      context 'titleに251文字以上入っている場合' do
        it 'エラーの文言が表示される' do
          visit edit_goal_path(goal)
          fill_in 'タイトル(250文字以内)', with: 'あ' * 251
          click_button '更新する'
          expect(page).to have_selector 'h2', text: 'あ' * 250
        end
      end
    end

    context 'フォームに正常な値を入力した場合' do
      it '目標を更新できる' do
        visit edit_goal_path(goal)
        fill_in 'タイトル(250文字以内)', with: '体重を50kgにする'
        fill_in '説明(500文字以内)', with: '毎日継続します！'
        click_button '更新する'
        expect(page).to have_selector 'h2', text: '体重を50kgにする'
      end
    end
  end
end