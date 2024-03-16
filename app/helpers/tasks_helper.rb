module TasksHelper
  def formatted_content(task)
    task.content.length <= 20 ? task.content : "#{task.content[0...20]}..."
  end
end
