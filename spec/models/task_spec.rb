# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  describe 'scope' do
    describe 'completed' do
      let!(:progress_user) { create(:task) }
      let!(:complete_task1) { create(:task, completed_at: '002024-4-01T00:00') }
      let!(:complete_task2) { create(:task, completed_at: '002024-4-01T00:00') }

      it '完了したタスクを取得できる' do
        expect(described_class.completed.length).to eq 2
      end
    end
  end

  describe '#formatted_content' do
    let(:task) { create(:task, content:) }

    context '内容が20文字の場合' do
      let(:content) { 'a' * 20 }

      it 'そのまま表示される' do
        expect(task.formatted_content).to eq content
      end
    end

    context '内容が21文字の場合' do
      let(:content) { 'a' * 21 }

      it '「20文字分+...」で表示される' do
        expect(task.formatted_content).to eq "#{'a' * 20}..."
      end
    end
  end
end
