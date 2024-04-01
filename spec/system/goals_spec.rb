# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Goals' do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#index' do
    before do
      create(:goal, title: 'サッカー選手になる')
      create(:goal, title: '野球選手になる')
    end

    it 'アクセスできる' do
      visit goals_path
      expect(page).to have_css 'h1', text: 'みんなの目標'
      expect(page).to have_content 'サッカー選手になる'
      expect(page).to have_content '野球選手になる'
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
          expect(page).to have_no_link '終了投稿する'
          expect(page).to have_no_link '修正する'
          expect(page).to have_no_button 'タスクを作成する'
        end
      end
    end

    context 'タスクがある場合' do
      before { create_list(:task, comment_count, goal:, created_at: 1.day.ago) }

      let(:comment_count) { 2 }
      let!(:old_task) { create(:task, goal:, created_at: 2.days.ago) }

      context 'タスクが3つ以下の場合' do
        it 'タスクが表示されている' do
          visit goal_path(goal)
          expect(page).to have_link old_task.content
        end
      end

      context 'タスクが4つの場合' do
        let!(:new_task) { create(:task, goal:, created_at: Time.current) }

        it '最新のタスクが表示されている' do
          visit goal_path(goal)
          expect(page).to have_link new_task.content
          expect(page).to have_no_link old_task.content
        end
      end
    end

    context 'コメントがある場合' do
      before { create_list(:comment, comment_count, commentable: goal, created_at: 1.day.ago) }

      let(:comment_count) { 2 }
      let!(:old_comment) { create(:comment, commentable: goal, created_at: 2.days.ago) }

      context 'コメントが3つ以下の場合' do
        it 'コメントが表示されている' do
          visit goal_path(goal)
          expect(page).to have_content old_comment.content
        end
      end

      context 'コメントが4つの場合' do
        let!(:new_comment) { create(:comment, commentable: goal, created_at: Time.current) }

        it '最新のコメントが表示されている' do
          visit goal_path(goal)
          expect(page).to have_content new_comment.content
          expect(page).to have_no_content old_comment.content
        end
      end
    end
  end

  describe '#new' do
    it 'アクセスできる' do
      visit new_goal_path
      expect(page).to have_css 'h1', text: '目標を作成する'
    end
  end

  describe '#edit' do
    let(:goal) { create(:goal, user:) }

    it 'アクセスできる' do
      visit edit_goal_path(goal)
      expect(page).to have_css 'h1', text: '目標を編集する'
      expect(page).to have_field 'タイトル(250文字以内)', with: goal.title
      expect(page).to have_field '説明(500文字以内)', with: goal.description
    end
  end

  describe '#create' do
    context 'フォームに不正な値を入力した場合' do
      context 'titleが空の場合' do
        it '送信できないこと' do
          visit new_goal_path
          click_on '作成する'
          expect(page).to have_css 'h1', text: '目標を作成する'
        end
      end

      context 'titleに251文字以上入っている場合' do
        it '250文字までしか入力できないこと' do
          visit new_goal_path
          fill_in 'タイトル(250文字以内)', with: 'あ' * 251
          fill_in '説明(500文字以内)', with: '毎日継続します！'
          click_on '作成する'
          expect(page).to have_css 'h2', text: 'あ' * 250
        end
      end
    end

    context 'フォームに正常な値を入力した場合' do
      it '目標を作成できる' do
        visit new_goal_path
        fill_in 'タイトル(250文字以内)', with: '体重を50kgにする'
        fill_in '説明(500文字以内)', with: '毎日継続します！'
        click_on '作成する'
        expect(page).to have_css 'h2', text: '体重を50kgにする'
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
          click_on '更新する'
          expect(page).to have_css 'h1', text: '目標を編集する'
        end
      end

      context 'titleに251文字以上入っている場合' do
        it 'エラーの文言が表示される' do
          visit edit_goal_path(goal)
          fill_in 'タイトル(250文字以内)', with: 'あ' * 251
          click_on '更新する'
          expect(page).to have_css 'h2', text: 'あ' * 250
        end
      end
    end

    context 'フォームに正常な値を入力した場合' do
      it '目標を更新できる' do
        visit edit_goal_path(goal)
        fill_in 'タイトル(250文字以内)', with: '体重を50kgにする'
        fill_in '説明(500文字以内)', with: '毎日継続します！'
        click_on '更新する'
        expect(page).to have_css 'h2', text: '体重を50kgにする'
      end
    end
  end
end
