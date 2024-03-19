# frozen_string_literal: true

class Tasks::CommentsController < ApplicationController
  before_action :set_task

  COMMENT_COUNT = 5

  def index
    @comments = @task.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @task.comments.build(comment_params)
    comment.user = current_user

    comment.save!

    # TODO: ここら辺ごそっとモデルに移行する
    Timeline.create!(user: current_user, content: "#{current_user.name}さんが#{@task.formatted_content}にコメントしました", url: task_comments_url(@task))

    is_create_notification = true
    comment.mentions.each do |comment_mention|
      mentioned_name = comment_mention[1..]
      mentioned_user = User.find_by(name: mentioned_name)

      next unless mentioned_user

      is_create_notification = false if @task.user == mentioned_user
      Notification.create!(user: mentioned_user, content: "コメントで#{current_user.name}さんからメンションされました", url: task_comments_url(@task))
    end

    if is_create_notification && !current_user?(@task.user)
      Notification.create!(user: @task.user, content: "#{@task.formatted_content}に#{current_user.name}さんからコメントがありました",
                           url: task_comments_url(@task))
    end
    redirect_to request.referer, notice: 'コメントを投稿しました'
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
