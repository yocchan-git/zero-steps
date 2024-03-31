require 'rails_helper'

RSpec.describe "Users::Sessions", type: :system do
  let(:user) { create(:user) }

  describe 'new' do
    it 'ログイン画面に遷移できること' do
      visit new_users_session_path
      expect(page).to have_button 'Discord アカウントでログイン'
    end
  end

  describe 'callback' do
    before { Rails.application.env_config["omniauth.auth"] = OmniAuth.config.add_mock(:discord, {uid: user.uid, info: { name: user.name, image: user.image }}) }

    context '初めてのユーザーの場合' do
      let(:user) { build(:user) }

      it '新規作成され、更新画面に遷移する' do
        visit new_users_session_path
        click_button 'Discord アカウントでログイン'
        expect(page).to have_selector '.text-success', text: 'ログインしました'
        expect(page).to have_selector 'h1', text: '企業の方ですか？'
      end
    end

    context '一度ログインしたことあるユーザーの場合' do
      it 'ログインし、タイムライン画面に遷移する' do
        visit new_users_session_path
        click_button 'Discord アカウントでログイン'
        expect(page).to have_selector '.text-success', text: 'ログインしました'
        expect(page).to have_selector 'h1', text: 'タイムライン'
      end
    end
  end

  describe 'failure' do
    before { OmniAuth.config.mock_auth[:discord] = :invalid_credentials }

    it 'ログインが失敗する' do
      visit new_users_session_path
      click_button 'Discord アカウントでログイン'
      expect(page).to have_selector '.text-danger', text: 'キャンセルしました'
      expect(page).to have_selector 'h1', text: 'ログイン'
    end
  end

  describe 'destroy' do
    it 'ログアウトする' do
      login(user)

      click_link 'ログアウト'
      expect(page).to have_selector '.text-success', text: 'ログアウトしました'
      expect(page).to have_selector 'h1', text: 'ログイン'
    end
  end
end
