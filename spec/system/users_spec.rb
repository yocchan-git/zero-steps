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
        click_on 'フォロー'
        expect(page).to have_content following_user.name
        expect(page).to have_no_content unfollowing_user.name
      end
    end
  end

  describe '#show' do
    context '公開ユーザーの場合' do
      let(:public_user) { create(:user, self_introduction:) }
      let(:self_introduction) { '' }

      it 'アクセスできる' do
        visit user_path(public_user)
        expect(page).to have_content public_user.name
        expect(page).to have_button 'フォローする'
      end

      context 'プロフィール' do
        context '自己紹介が存在しない場合' do
          it '自己紹介が表示される' do
            visit user_path(public_user)

            expect(page).to have_css 'h2', text: '自己紹介'
            expect(page).to have_content '自己紹介がありません'
          end
        end

        context '自己紹介が存在する場合' do
          let(:self_introduction) { 'よっちゃんです。仲良くしてね' }

          it '自己紹介が表示される' do
            visit user_path(public_user)

            expect(page).to have_css 'h2', text: '自己紹介'
            expect(page).to have_content 'よっちゃんです。仲良くしてね'
          end
        end
      end

      context '目標' do
        context '目標がない場合' do
          it '目標が表示されない' do
            visit user_path(public_user, is_goals: true)
            expect(page).to have_css 'h2', text: '目標'
            expect(page).to have_content '目標がありません'
          end
        end

        context '目標がある場合' do
          before { create(:goal, user: public_user, title: '体重を50kgにする') }

          it '目標が表示される' do
            visit user_path(public_user, is_goals: true)
            expect(page).to have_css 'h2', text: '目標'
            expect(page).to have_content '体重を50kgにする'
          end
        end
      end

      context 'タスク' do
        context 'タスクがある場合' do
          it 'タスクが表示されない' do
            visit user_path(public_user, is_tasks: true)
            expect(page).to have_css 'h2', text: 'タスク'
            expect(page).to have_content 'タスクがありません'
          end
        end

        context 'タスクがない場合' do
          before { create(:task, user: public_user, content: 'ジムに入会する') }

          it 'タスクが表示される' do
            visit user_path(public_user, is_tasks: true)
            expect(page).to have_css 'h2', text: 'タスク'
            expect(page).to have_content 'ジムに入会する'
          end
        end
      end

      context 'コメント' do
        context 'コメントがない場合' do
          it 'コメントが表示されない' do
            visit user_path(public_user, is_comments: true)
            expect(page).to have_css 'h2', text: 'コメント'
            expect(page).to have_content 'コメントがありません'
          end
        end

        context 'コメントがある場合' do
          before { create(:comment, user: public_user, content: '応援しています！') }

          it 'コメントが表示される' do
            visit user_path(public_user, is_comments: true)
            expect(page).to have_css 'h2', text: 'コメント'
            expect(page).to have_content '応援しています！'
          end
        end
      end
    end

    context '非公開ユーザーの場合' do
      context '他人が見る場合' do
        let(:other_user) { create(:user, is_hidden: true) }

        it 'アクセスできない' do
          visit user_path(other_user)
          expect(page).to have_css 'h1', text: 'ユーザー一覧'
          expect(page).to have_css '.alert-danger', text: 'このユーザーにはアクセスできません'
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
      expect(page).to have_css 'h1', text: 'ユーザー編集'
    end

    context 'テンプレートを使うを押した場合', :js do
      it '自己紹介のテキストエリアにテンプレが挿入される' do
        visit edit_user_path(user)
        click_on 'テンプレートを使う'
        expect(page).to have_field '自己紹介', with: "■性格\n\n\n■好きなこと・趣味\n\n\n■今やっていること\n\n\n■将来どうなりたいか\n\n\n■卒業後の進路\n"
      end
    end
  end

  describe '#update' do
    it '更新できること' do
      visit edit_user_path(user)
      check '非公開にする'
      click_on '更新する'
      expect(page).to have_css '.alert-success', text: 'ユーザー情報を更新しました'
    end

    it '自己紹介も更新できること' do
      visit edit_user_path(user)
      fill_in '自己紹介', with: 'よっちゃんと申します！よろしくお願いします'
      click_on '更新する'
      expect(page).to have_css '.alert-success', text: 'ユーザー情報を更新しました'
      expect(page).to have_content 'よっちゃんと申します！よろしくお願いします'
    end
  end
end
