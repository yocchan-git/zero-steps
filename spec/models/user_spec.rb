# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'scope' do
    describe 'active' do
      let!(:active_user) { create(:user) }
      let!(:hidden_user) { create(:user, is_hidden: true) }

      it '非公開でないユーザーを取得できる' do
        expect(described_class.active).to include active_user
        expect(described_class.active).not_to include hidden_user
      end
    end
  end

  describe '.fetch_multiple' do
    let(:fetch_timelines) { described_class.fetch_multiple(user:, is_only_follows:) }
    let(:user) { create(:user) }
    let(:following_user) { create(:user) }
    let(:unfollowing_user) { create(:user) }

    before { user.follow(following_user) }

    context 'フォローしていない人も含む場合' do
      let(:is_only_follows) { false }

      it 'フォローしていない人のタイムラインも取得できる' do
        expect(fetch_timelines).to include following_user, unfollowing_user
      end
    end

    context 'フォローしている人に絞り込む場合' do
      let(:is_only_follows) { true }

      it 'フォローしている人だけのタイムラインが取得できる' do
        expect(fetch_timelines).to include following_user
        expect(fetch_timelines).not_to include unfollowing_user
      end
    end
  end

  describe '.auth_discord' do
    let(:authentication) { User.auth_discord(auth) }
    let(:auth) { OmniAuth::AuthHash.new({ provider: 'discord', uid: '123456', info: { name: 'yocchan', image: 'https://discord.cdn.example.com' } }) }

    context '新しく作成されるユーザーの場合' do
      it 'userは新規作成され、is_new_userはtrueになる' do
        expect(authentication[:user].uid).to eq '123456'
        expect(authentication[:user].name).to eq 'yocchan'
        expect(authentication[:user].image).to eq 'https://discord.cdn.example.com'
        expect(authentication[:is_new_user]).to be_truthy
      end
    end

    context 'すでに作成されているユーザーの場合' do
      let!(:user) { create(:user, uid: '123456') }

      it 'userの値は正しく、is_new_userはfalseになる' do
        expect(authentication[:user]).to eq user
        expect(authentication[:is_new_user]).to be_falsey
      end
    end
  end

  describe '#follow' do
    let(:follwoing_user) { create(:user) }
    let(:followed_user) { create(:user) }

    context 'フォロー対象が自分以外の場合' do
      it 'フォローできること' do
        follwoing_user.follow(followed_user)
        expect(follwoing_user.following).to include(followed_user)
      end
    end

    context 'フォロー対象が自分の場合' do
      it 'フォローできないこと' do
        follwoing_user.follow(follwoing_user)
        expect(follwoing_user.following).not_to include(follwoing_user)
      end
    end
  end

  describe '#unfollow' do
    let(:follwoing_user) { create(:user) }
    let(:followed_user) { create(:user) }

    before { follwoing_user.follow(followed_user) }

    it 'フォロー解除できること' do
      follwoing_user.unfollow(followed_user)
      expect(follwoing_user.following).not_to include(followed_user)
    end
  end

  describe '#following?' do
    let(:follwoing_user) { create(:user) }
    let(:followed_user) { create(:user) }
    let(:unfollowed_user) { create(:user) }

    context '対象ユーザーがフォローしている場合' do
      before { follwoing_user.follow(followed_user) }

      it 'trueを返す' do
        expect(follwoing_user).to be_following(followed_user)
      end
    end

    context '対象ユーザーをフォローしていない場合' do
      it 'falseを返す' do
        expect(follwoing_user).not_to be_following(unfollowed_user)
      end
    end
  end
end
