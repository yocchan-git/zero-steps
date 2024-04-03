# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Timelineable do
  describe 'formatted_text' do
    context '目標の場合' do
      let(:goal) { create(:goal, title:) }

      context '20文字以下の場合' do
        let(:title) { 'a' * 20 }

        it '全文が表示される' do
          expect(formatted_text(goal)).to eq title
        end
      end

      context '21文字以上の場合' do
        let(:title) { 'a' * 21 }

        it '「20文字...」になる' do
          expect(formatted_text(goal)).to eq "#{'a' * 20}..."
        end
      end
    end

    context 'タスクの場合' do
      let(:task) { create(:task, content:) }

      context '20文字の場合' do
        let(:content) { 'a' * 20 }

        it '全文が表示される' do
          expect(formatted_text(task)).to eq content
        end
      end

      context '21文字以上の場合' do
        let(:content) { 'a' * 21 }

        it '「20文字...」になる' do
          expect(formatted_text(task)).to eq "#{'a' * 20}..."
        end
      end
    end

    context 'コメントの場合' do
      let(:comment) { create(:comment, content:) }

      context '20文字の場合' do
        let(:content) { 'a' * 20 }

        it '全文が表示される' do
          expect(formatted_text(comment)).to eq content
        end
      end

      context '21文字以上の場合' do
        let(:content) { 'a' * 21 }

        it '「20文字...」になる' do
          expect(formatted_text(comment)).to eq "#{'a' * 20}..."
        end
      end
    end

    context '終了投稿の場合' do
      let(:complete_post) { create(:complete_post, content:) }

      context '20文字の場合' do
        let(:content) { 'a' * 20 }

        it '全文が表示される' do
          expect(formatted_text(complete_post)).to eq content
        end
      end

      context '21文字以上の場合' do
        let(:content) { 'a' * 21 }

        it '「20文字...」になる' do
          expect(formatted_text(complete_post)).to eq "#{'a' * 20}..."
        end
      end
    end
  end
end
