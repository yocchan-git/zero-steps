# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks::Comments' do
  before { login(user) }

  let(:user) { create(:user) }
  let(:task) { create(:task) }

  describe '#index' do
    let!(:comment) { create(:comment, commentable: task) }
    let!(:other_comment) { create(:comment) }

    it '目標に紐づくコメントが表示される' do
      visit task_comments_path(task)
      expect(page).to have_content comment.content
      expect(page).to have_no_content other_comment.content
    end
  end

  describe '#create' do
    before { allow(Discordrb::API::Channel).to receive(:create_message).and_return('Discordに通知しました') }

    it 'コメントできること' do
      visit task_comments_path(task)
      fill_in 'コメント(500文字以内)', with: 'かっこいい目標ですね'
      click_on 'コメントする'
      expect(page).to have_content 'かっこいい目標ですね'
    end
  end
end
