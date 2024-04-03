# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompleteUpdater do
  let(:complete_updater) { described_class.new(complete_postable, user, params) }

  describe '#execute' do
    subject { complete_updater.execute }

    before { freeze_time }

    let(:user) { create(:user) }
    let(:params) { { content: '終了しました！応援ありがとうございます' } }

    context '目標の場合' do
      let(:complete_postable) { create(:goal) }

      it 'completed_atが設定される' do
        subject

        expect(complete_postable.completed_at).to eq Time.current
      end

      it '終了投稿が作成される' do
        expect { subject }.to change { CompletePost.count }.by(1)
      end

      it 'タイムラインが作成される' do
        expect { subject }.to change { Timeline.count }.by(1)
      end
    end

    context 'タスクの場合' do
      let(:complete_postable) { create(:task) }

      it 'completed_atが設定される' do
        subject

        expect(complete_postable.completed_at).to eq Time.current
      end

      it '終了投稿が作成される' do
        expect { subject }.to change { CompletePost.count }.by(1)
      end

      it 'タイムラインが作成される' do
        expect { subject }.to change { Timeline.count }.by(1)
      end
    end
  end
end
