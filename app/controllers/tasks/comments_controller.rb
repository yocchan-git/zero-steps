# frozen_string_literal: true

class Tasks::CommentsController < ApplicationController
  before_action :check_hide_user, only: %i[create]
  before_action :set_task

  COMMENT_COUNT = 5

  def index
    @comments = @task.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @task.comments.build(comment_params)
    comment.user = current_user

    comment.save!

    # ここリファクタリングする
    comment.create_mention_notification

    comment.timelines.create!(user: current_user, content: "#{current_user.name}さんが#{@task.formatted_content}にコメントしました")
    if comment.mention_other_than_commentable_user? && !current_user?(@task.user)
      comment.notifications.create!(user: @task.user, content: "#{@task.formatted_content}に#{current_user.name}さんからコメントがありました")
      comment.send_message_to_discord(send_user: @task.user, notification_type: :comment)
    end

    respond_to do |format|
      format.html { redirect_to task_comments_path(@task) }
      format.turbo_stream
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
