# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users' do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#index' do
    before { user.follow(following_user) }

    let!(:following_user) { create(:user) }
    let!(:unfollowing_user) { create(:user) }

    context '全員表示する場合' do
      it '全員表示される' do
        visit users_path
        expect(page).to have_content following_user.name
        expect(page).to have_content unfollowing_user.name
      end
    end

    context 'フォローしている人に絞り込んだ場合' do
      it 'フォローしている人だけに絞り込まれる' do
        visit users_path
        click_link 'フォローしている人で絞り込む'
        expect(page).to have_content following_user.name
        expect(page).to have_no_content unfollowing_user.name
      end
    end
  end

  describe '#show' do
    context '公開ユーザーの場合' do
      let(:public_user) { create(:user) }

      it 'アクセスできる' do
        visit user_path(public_user)
        expect(page).to have_content public_user.name
        expect(page).to have_button 'フォローする'
      end
    end

    context '非公開ユーザーの場合' do
      context '他人が見る場合' do
        let(:other_user) { create(:user, is_hidden: true) }

        it 'アクセスできない' do
          visit user_path(other_user)
          expect(page).to have_css 'h1', text: 'ユーザー一覧'
          expect(page).to have_css '.text-danger', text: 'このユーザーにはアクセスできません'
        end
      end

      context '自分で見た場合' do
        let(:user) { create(:user, is_hidden: true) }

        it 'アクセスできる' do
          visit user_path(user)
          expect(page).to have_content user.name
          expect(page).to have_link '修正する'
        end
      end
    end
  end

  describe '#edit' do
    it 'アクセスできること' do
      visit edit_user_path(user)
      expect(page).to have_css 'h1', text: '企業の方ですか？'
    end
  end

  describe '#update' do
    it '更新できること' do
      visit edit_user_path(user)
      check '非公開アカウントにする'
      click_button '更新する'
      expect(page).to have_css '.text-success', text: 'ユーザー情報を更新しました'
    end
  end
end
