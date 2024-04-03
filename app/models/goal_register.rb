class GoalRegister
  include Timelineable

  attr_reader :goal

  def initialize(user, params)
    @user = user
    @params = params
  end

  def execute
    @goal = @user.goals.create(@params)
    @goal.timelines.create!(user: @user, content: "#{@user.name}さんが#{formatted_text(@goal)}という目標を作成しました")
  end
end
