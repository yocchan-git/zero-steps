require 'rails_helper'

RSpec.describe "Tasks::Comments", type: :system do
  before { login(user) }
  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe '#index' do
    let!(:task_comment1) { create(:comment, commentable: task) }
    let!(:task_comment2) { create(:comment, commentable: task) }
    let!(:other_task_comment) { create(:comment)}

    it '目標に紐づくコメントが表示される' do
      visit task_comments_path(task)
      expect(page).to have_content task_comment1.content
      expect(page).to have_content task_comment2.content
      expect(page).not_to have_content other_task_comment.content
    end
  end

  describe '#create' do
    before { allow(Discordrb::API::Channel).to receive(:create_message).and_return("Discordに通知しました") }

    it 'コメントできること' do
      visit task_comments_path(task)
      fill_in 'コメント(500文字以内)', with: 'かっこいい目標ですね'
      click_button 'コメントする'
      expect(page).to have_content 'かっこいい目標ですね'
    end
  end
end
