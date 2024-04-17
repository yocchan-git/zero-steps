# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksHelper do
  describe 'recent_tasks' do
    before { create_list(:task, sample_count, goal:, user:, created_at: 1.day.ago) }

    let!(:recent_task) { create(:task, goal:, user:, created_at: Time.current) }
    let!(:old_task) { create(:task, goal:, user:, created_at: 2.days.ago) }

    let(:goal) { create(:goal) }
    let(:user) { create(:user) }
    let(:sample_count) { task_count - 1 }

    context '目標の場合' do
      let(:tasks) { recent_tasks(goal, task_count:) }

      context 'task_countが3の時' do
        let(:task_count) { 3 }

        it '最近のタスクを取得できる' do
          expect(tasks).to include(recent_task)
          expect(tasks).not_to include(old_task)
        end

        it '3つタスクが取得できる' do
          expect(tasks.length).to eq 3
        end
      end

      context 'task_countが5の時' do
        let(:task_count) { 5 }

        it '5つタスクが取得できる' do
          expect(tasks.length).to eq 5
        end
      end
    end

    context 'ユーザーの場合' do
      let(:tasks) { recent_tasks(goal, task_count:) }
      let(:task_count) { 3 }

      it '最近のタスクを取得できる' do
        expect(tasks).to include(recent_task)
        expect(tasks).not_to include(old_task)
      end
    end
  end
end
