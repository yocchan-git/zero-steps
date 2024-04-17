# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Friendships' do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#create' do
    let!(:other_user) { create(:user) }

    context 'ユーザー一覧ページからフォローした場合' do
      it 'フォローボタンが変わる' do
        visit users_path
        click_on 'フォローする'
        expect(page).to have_button 'フォロー解除'
      end
    end

    context 'ユーザー詳細ページからフォローした場合' do
      it 'フォローボタンが変わる' do
        visit user_path(other_user)
        click_on 'フォローする'
        expect(page).to have_button 'フォロー解除'
      end
    end
  end

  describe '#destroy' do
    before { user.follow(other_user) }

    let(:other_user) { create(:user) }

    context 'ユーザー一覧ページからフォロー解除した場合' do
      it 'フォローボタンが変わる' do
        visit users_path
        click_on 'フォロー解除'
        expect(page).to have_button 'フォローする'
      end
    end

    context 'ユーザー詳細ページからフォロー解除した場合' do
      it 'フォローボタンが変わる' do
        visit user_path(other_user)
        click_on 'フォロー解除'
        expect(page).to have_button 'フォローする'
      end
    end
  end
end
