module GoalsHelper
  def formatted_title(goal)
    goal.title.length <= 20 ? goal.title : "#{goal.title[0...15]}..."
  end
end
