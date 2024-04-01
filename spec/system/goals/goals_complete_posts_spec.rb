require 'rails_helper'

RSpec.describe "Goals::CompletePosts", type: :system do
  before { login(user) }
  let(:user) { create(:user) }
  let(:goal) { create(:goal, user:) }

  describe '#new' do
    it 'アクセスできる' do
      visit new_goal_complete_post_path(goal)
      expect(page).to have_selector 'h1', text: "#{goal.formatted_title}の終了投稿"
    end
  end

  describe '#create' do
    it '終了投稿できること' do
      visit new_goal_complete_post_path(goal)
      fill_in '内容(500文字以内)', with: 'この目標は終了しました'
      click_button '投稿する'
      expect(page).to have_selector 'h2', text: '終了投稿'
      expect(page).to have_content 'この目標は終了しました'
    end
  end
end
