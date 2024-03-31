require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  describe 'current_user' do
    context 'ログインしていない場合' do
      it 'nilが返る' do
        expect(current_user).to be nil
      end
    end

    context 'ログインしている場合' do
      before { log_in(user) }
      let(:user) { create(:user) }

      it 'ログインユーザーを返す' do
        expect(current_user).to eq user
      end
    end
  end

  describe 'logged_in?' do
    context 'ログインしていない場合' do
      it 'falseが返る' do
        expect(logged_in?).to be_falsy
      end
    end

    context 'ログインしている場合' do
      before { log_in(user) }
      let(:user) { create(:user) }

      it 'trueが返る' do
        expect(logged_in?).to be_truthy
      end
    end
  end

  describe 'current_user?' do
    before { log_in(user) }
    let(:user) { create(:user) }

    context 'userがnilの場合' do
      it 'falseを返す' do
        expect(current_user?(nil)).to be_falsy
      end
    end

    context 'userがcurrent_userと別の場合' do
      let(:other_user) { create(:user) }

      it 'falseを返す' do
        expect(current_user?(other_user)).to be_falsy
      end
    end

    context 'userがcurrent_userと一致する場合' do
      it 'trueを返す' do
        expect(current_user?(user)).to be_truthy
      end
    end
  end

  describe 'log_in' do
    let(:user) { create(:user) }

    it 'session[:user_id]にユーザーIDが入る' do
      log_in(user)
      expect(session[:user_id]).to eq user.id
    end
  end

  describe 'log_out' do
    before { log_in(user) }
    let(:user) { create(:user) }

    it 'session[:user_id]とcurrent_userがnilになる' do
      log_out

      expect(session[:user_id]).to be nil
      expect(current_user).to be nil
    end
  end
end
