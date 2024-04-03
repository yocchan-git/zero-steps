require 'rails_helper'

RSpec.describe TaskRegister, type: :model do
  let(:task_register) { described_class.new(goal, params) }

  describe '#execute' do
    subject { task_register.execute }

    let(:goal) { create(:goal) }
    let(:params) { { content: 'ジムに入会する', completion_limits: '002024-4-01T00:00'} }

    it 'タスクとタイムラインが作成できること' do
      expect { subject }.to change { Task.count }.by(1).and change { Timeline.count }.by(1)
    end

    it 'goalにもアクセスできること' do
      subject

      expect(task_register.goal).to eq goal
    end
  end
end
