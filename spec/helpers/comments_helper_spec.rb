# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsHelper do
  describe 'recent_comments' do
    before { create_list(:comment, sample_count, commentable:, created_at: 1.day.ago) }

    let!(:recent_comment) { create(:comment, commentable:, created_at: Time.current) }
    let!(:old_comment) { create(:comment, commentable:, created_at: 2.day.ago) }

    let(:comments) { recent_comments(commentable, comment_count:) }
    let(:sample_count) { comment_count - 1 }

    context '目標の場合' do
      let(:commentable) { create(:goal) }

      context 'comment_countが3の時' do
        let(:comment_count) { 3 }

        it '最近のコメントを取得できる' do
          expect(comments).to include(recent_comment)
          expect(comments).not_to include(old_comment)
        end

        it '3つコメントが取得できる' do
          expect(comments.length).to eq 3
        end
      end

      context 'comment_countが5の時' do
        let(:comment_count) { 5 }

        it '5つコメントが取得できる' do
          expect(comments.length).to eq 5
        end
      end
    end

    context 'タスクの場合' do
      let(:commentable) { create(:task) }
      let(:comment_count) { 3 }

      it '最近のコメントを取得できる' do
        expect(comments).to include(recent_comment)
        expect(comments).not_to include(old_comment)
      end
    end
  end

  describe 'link_text' do
    context 'commentsが空の場合' do
      let(:comments) { [] }

      it '「コメント受付中」の文言が返る' do
        expect(link_text(comments)).to eq 'コメント受付中'
      end
    end

    context 'commentsに値がある場合' do
      let(:comments) { [comment] }
      let(:comment) { create(:comment) }

      it '「もっと見る」の文言が返る' do
        expect(link_text(comments)).to eq 'もっと見る'
      end
    end
  end

  describe 'comment_index_url' do
    let(:url) { comment_index_url(commentable) }

    context '目標の場合' do
      let(:commentable) { create(:goal) }

      it '目標コメント一覧のパスが返る' do
        expect(url).to eq goal_comments_path(commentable)
      end
    end

    context 'タスクの場合' do
      let(:commentable) { create(:task) }

      it 'タスクコメント一覧のパスが返る' do
        expect(url).to eq task_comments_path(commentable)
      end
    end
  end
end
