# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task do
  describe 'scope' do
    describe 'completed' do
      let!(:progress_task) { create(:task) }
      let!(:completed_task) { create(:task, completed_at: '002024-4-01T00:00') }

      it '完了したタスクを取得できる' do
        expect(described_class.completed).not_to include progress_task
        expect(described_class.completed).to include completed_task
      end
    end
  end
end
