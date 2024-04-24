# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimelinesHelper do
  describe 'comment_text' do
    before { create_list(:comment, 2, commentable:) }

    let(:comment_text_with_counts) { comment_text(timeline.timelineable) }

    context '目標の場合' do
      let(:timeline) { create(:timeline) }
      let(:commentable) { timeline.timelineable }

      it '「コメント ◯」が返る' do
        expect(comment_text_with_counts).to eq 'コメント 2'
      end
    end

    context 'タスクの場合' do
      let(:timeline) { create(:timeline, :task) }
      let(:commentable) { timeline.timelineable }

      it '「コメント ◯」が返る' do
        expect(comment_text_with_counts).to eq 'コメント 2'
      end
    end

    context '終了投稿の場合' do
      let(:timeline) { create(:timeline, :complete_post) }
      let(:commentable) { timeline.timelineable.complete_postable }

      it '「コメント ◯」が返る' do
        expect(comment_text_with_counts).to eq 'コメント 2'
      end
    end

    context 'コメントの場合' do
      let(:timeline) { create(:timeline, :comment) }
      let(:commentable) { create(:goal) }

      it '空文字が返る' do
        expect(comment_text_with_counts).to eq ''
      end
    end
  end
end
