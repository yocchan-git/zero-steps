# frozen_string_literal: true

class TaskRegister
  include Timelineable

  attr_reader :task

  def initialize(goal, params)
    @goal = goal
    @params = params
  end

  def execute
    create_task
    @task.timelines.create!(user: @goal.user, content: "#{formatted_text(task)}というタスクを作成しました")
  end

  private

  def create_task
    @task = @goal.tasks.build(@params)
    @task.user = @goal.user
    @task.save!
  end
end
