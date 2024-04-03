require 'rails_helper'

RSpec.describe GoalRegister, type: :model do
  let(:goal_register) { described_class.new(user, params) }

  describe '#execute' do
    subject { goal_register.execute }

    let(:user) { create(:user) }
    let(:params) { { title: '夏までに痩せる', description: '海に行きたいので、痩せます'} }

    it '目標とタイムラインが作成できること' do
      expect { subject }.to change { Goal.count }.by(1).and change { Timeline.count }.by(1)
    end
  end
end
