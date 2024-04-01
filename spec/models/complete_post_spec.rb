# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompletePost do
  include Rails.application.routes.url_helpers

  describe '#complete_post_url' do
    context '目標の終了投稿の場合' do
      let(:complete_post) { create(:complete_post) }

      it '目標詳細画面のリンクが返る' do
        expect(complete_post.complete_post_url).to eq goal_path(complete_post.complete_postable)
      end
    end

    context 'タスクの終了投稿の場合' do
      let(:complete_post) { create(:complete_post, :task) }
      let(:complete_postable) { complete_post.complete_postable }

      it 'タスク詳細画面のリンクが返る' do
        expect(complete_post.complete_post_url).to eq goal_task_path(complete_postable, goal_id: complete_postable.goal.id)
      end
    end
  end
end
