require 'rails_helper'

RSpec.describe "Goals::Comments", type: :system do
  before { login(user) }
  let(:user) { create(:user) }
  let(:goal) { create(:goal) }

  describe '#index' do
    let!(:goal_comment1) { create(:comment, commentable: goal) }
    let!(:goal_comment2) { create(:comment, commentable: goal) }
    let!(:other_goal_comment) { create(:comment)}

    it '目標に紐づくコメントが表示される' do
      visit goal_comments_path(goal)
      expect(page).to have_content goal_comment1.content
      expect(page).to have_content goal_comment2.content
      expect(page).not_to have_content other_goal_comment.content
    end
  end

  describe '#create' do
    before { allow(Discordrb::API::Channel).to receive(:create_message).and_return("Discordに通知しました") }

    it 'コメントできること' do
      visit goal_comments_path(goal)
      fill_in 'コメント(500文字以内)', with: 'かっこいい目標ですね'
      click_button 'コメントする'
      expect(page).to have_content 'かっこいい目標ですね'
    end
  end
end
