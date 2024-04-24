# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Timelines' do
  before { login(user) }

  let(:user) { create(:user) }

  describe '#index' do
    before { user.follow(following_user) }

    let(:following_user) { create(:user) }
    let(:unfollowing_user) { create(:user) }
    let!(:following_user_timeline) { create(:timeline, user: following_user, content: 'フォローしている人のタイムライン') }
    let!(:unfollowing_user_timeline) { create(:timeline, user: unfollowing_user, content: 'フォローしていない人のタイムライン') }

    context '絞り込みをしていない場合' do
      it '全員のタイムラインが表示される' do
        visit timelines_path
        expect(page).to have_css 'h1', text: 'タイムライン'
        expect(page).to have_link following_user_timeline.content
        expect(page).to have_link unfollowing_user_timeline.content
      end
    end

    context 'フォローしている人で絞り込んだ場合' do
      it 'フォローしている人のタイムラインだけ表示される' do
        visit timelines_path
        click_on 'フォロー'
        expect(page).to have_link following_user_timeline.content
        expect(page).to have_no_link unfollowing_user_timeline.content
      end
    end
  end
end
