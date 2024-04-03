# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Timeline do
  include Rails.application.routes.url_helpers

  describe '.fetch_multiple' do
    let(:fetch_timelines) { described_class.fetch_multiple(user, is_only_follows, page_count) }

    before { user.follow(following_user) }

    let(:user) { create(:user) }
    let(:page_count){ 1 }

    let(:following_user) { create(:user) }
    let(:unfollowing_user) { create(:user) }

    let!(:following_user_timeline) { create(:timeline, user: following_user) }
    let!(:unfollowing_user_timeline) { create(:timeline, user: unfollowing_user) }


    context 'フォローしていない人も含む場合' do
      let(:is_only_follows) { false }

      it 'フォローしていない人のタイムラインも取得できる' do
        expect(fetch_timelines).to include following_user_timeline, unfollowing_user_timeline
      end
    end

    context 'フォローしている人に絞り込む場合' do
      let(:is_only_follows) { true }

      it 'フォローしている人だけのタイムラインが取得できる' do
        expect(fetch_timelines).to include following_user_timeline
        expect(fetch_timelines).not_to include unfollowing_user_timeline
      end
    end
  end

  describe '#timelineable_url' do
    let(:timeline) { create(:timeline) }
    let(:timelineable) { timeline.timelineable }

    context '目標のタイムラインの場合' do
      it '目標詳細のURLが返る' do
        expect(timeline.timelineable_url).to eq goal_path(timelineable)
      end
    end

    context 'タスクのタイムラインの場合' do
      let(:timeline) { create(:timeline, :task) }

      it 'タスク詳細のURLが返る' do
        expect(timeline.timelineable_url).to eq goal_task_path(timelineable, goal_id: timelineable.goal.id)
      end
    end

    context 'コメントのタイムラインの場合' do
      let(:timeline) { create(:timeline, :comment) }

      it 'comment_urlメソッドが呼ばれる' do
        allow(timelineable).to receive(:comment_url)
        timeline.timelineable_url

        expect(timelineable).to have_received(:comment_url)
      end
    end

    context '終了投稿のタイムラインの場合' do
      let(:timeline) { create(:timeline, :complete_post) }

      it 'complete_post_urlメソッドが呼ばれる' do
        allow(timelineable).to receive(:complete_post_url)
        timeline.timelineable_url

        expect(timelineable).to have_received(:complete_post_url)
      end
    end
  end
end
