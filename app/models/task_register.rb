class TaskRegister
  include Timelineable

  attr_reader :goal

  def initialize(goal, params)
    @goal = goal
    @params = params
  end

  def execute
    task = create_task
    task.timelines.create!(user: @goal.user, content: "#{@goal.user.name}さんが#{formatted_text(task)}というタスクを作成しました")
  end

  private

  def create_task
    task = @goal.tasks.build(@params)
    task.user = @goal.user
    task.save!

    task
  end
end
