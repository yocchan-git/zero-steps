require 'rails_helper'

RSpec.describe Timeline, type: :model do
  include Rails.application.routes.url_helpers

  describe '#timelineable_url' do
    subject { timeline.timelineable_url }

    let(:timeline) { create(:timeline) }
    let(:timelineable) { timeline.timelineable }

    context '目標のタイムラインの場合' do
      it { is_expected.to eq goal_path(timelineable) }
    end

    context 'タスクのタイムラインの場合' do
      let(:timeline) { create(:timeline, :task) }

      it { is_expected.to eq goal_task_path(timelineable, goal_id: timelineable.goal.id) }
    end

    context 'コメントのタイムラインの場合' do
      let(:timeline) { create(:timeline, :comment) }

      it 'comment_urlメソッドが呼ばれる' do
        allow(timelineable).to receive(:comment_url)
        subject

        expect(timelineable).to have_received(:comment_url)
      end
    end

    context '終了投稿のタイムラインの場合' do
      let(:timeline) { create(:timeline, :complete_post) }

      it 'complete_post_urlメソッドが呼ばれる' do
        allow(timelineable).to receive(:complete_post_url)
        subject

        expect(timelineable).to have_received(:complete_post_url)
      end
    end
  end
end
