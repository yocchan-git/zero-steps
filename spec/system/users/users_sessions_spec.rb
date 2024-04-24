# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::Sessions' do
  let(:user) { create(:user) }

  describe '#new' do
    it 'ログイン画面に遷移できること' do
      visit new_users_session_path
      expect(page).to have_button 'Discord アカウントでログイン'
    end
  end

  describe '#callback' do
    before { OmniAuth.config.add_mock(:discord, { uid: user.uid, info: { name: user.name, image: user.image } }) }

    context '初めてのユーザーの場合' do
      let(:user) { build(:user) }

      it '新規作成され、更新画面に遷移する' do
        visit new_users_session_path
        click_on 'Discord アカウントでログイン'
        expect(page).to have_css '.alert-success', text: 'ログインしました'
        expect(page).to have_css 'h1', text: 'ユーザー登録'
      end
    end

    context '一度ログインしたことあるユーザーの場合' do
      it 'ログインし、タイムライン画面に遷移する' do
        visit new_users_session_path
        click_on 'Discord アカウントでログイン'
        expect(page).to have_css '.alert-success', text: 'ログインしました'
        expect(page).to have_css 'h1', text: 'タイムライン'
      end
    end
  end

  describe '#failure' do
    before { OmniAuth.config.mock_auth[:discord] = :invalid_credentials }

    it 'ログインが失敗する' do
      visit new_users_session_path
      click_on 'Discord アカウントでログイン'
      expect(page).to have_css '.alert-danger', text: 'キャンセルしました'
      expect(page).to have_css 'h1', text: 'ログイン'
    end
  end

  describe '#destroy' do
    it 'ログアウトする' do
      login(user)

      click_on 'ログアウト'
      expect(page).to have_css '.alert-success', text: 'ログアウトしました'
      expect(page).to have_css 'h1', text: 'ログイン'
    end
  end
end
