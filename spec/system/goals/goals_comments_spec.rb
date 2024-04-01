# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Goals::Comments' do
  before { login(user) }

  let(:user) { create(:user) }
  let(:goal) { create(:goal) }

  describe '#index' do
    before do
      create(:comment, content: '目標面白い', commentable: goal)
      create(:comment, content: '僕も筋トレする', commentable: goal)
      create(:comment, content: 'パーティしましょう')
    end

    it '目標に紐づくコメントが表示される' do
      visit goal_comments_path(goal)
      expect(page).to have_content '目標面白い'
      expect(page).to have_content '僕も筋トレする'
      expect(page).to have_no_content 'パーティしましょう'
    end
  end

  describe '#create' do
    before { allow(Discordrb::API::Channel).to receive(:create_message).and_return('Discordに通知しました') }

    it 'コメントできること' do
      visit goal_comments_path(goal)
      fill_in 'コメント(500文字以内)', with: 'かっこいい目標ですね'
      click_on 'コメントする'
      expect(page).to have_content 'かっこいい目標ですね'
    end
  end
end
