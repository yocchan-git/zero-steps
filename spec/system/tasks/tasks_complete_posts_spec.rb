# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks::CompletePosts' do
  before { login(user) }

  let(:user) { create(:user) }
  let(:task) { create(:task, user:) }

  describe '#new' do
    it 'アクセスできる' do
      visit new_task_complete_post_path(task)
      expect(page).to have_css 'h1', text: "#{task.formatted_content}の終了投稿"
    end
  end

  describe '#create' do
    it '終了投稿できること' do
      visit new_task_complete_post_path(task)
      fill_in '内容(500文字以内)', with: 'このタスクは終了しました'
      click_button '投稿する'
      expect(page).to have_css 'h2', text: '終了投稿'
      expect(page).to have_content 'このタスクは終了しました'
    end
  end
end
