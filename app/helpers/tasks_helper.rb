# frozen_string_literal: true

module TasksHelper
  def recent_tasks(resource, task_count:)
    resource.tasks.eager_load(:user).order(created_at: :desc).limit(task_count)
  end
end
