class Goals::CommentsController < ApplicationController
  before_action :set_goal

  COMMENT_COUNT = 5

  def index
    @comments = @goal.comments.includes(:user).order(created_at: :desc).page(params[:page]).per(COMMENT_COUNT)
  end

  def create
    comment = @goal.comments.build(comment_params)
    comment.user = current_user

    comment.save!
    Timeline.create!(user: current_user, content: "#{current_user.name}さんが#{@goal.formatted_title}にコメントしました", url: goal_comments_url(@goal))

    is_create_notification = true
    comment.mentions.each do |comment_mention|
      mentioned_name = comment_mention[1..]
      mentioned_user = User.find_by(name: mentioned_name)

      next unless mentioned_user

      is_create_notification = false if @goal.user == mentioned_user
      Notification.create!(user: mentioned_user, content: "コメントで#{current_user.name}さんからメンションされました", url: goal_comments_url(@goal))
    end

    Notification.create!(user: @goal.user, content: "#{@goal.formatted_title}に#{current_user.name}さんからコメントがありました", url: goal_comments_url(@goal)) if is_create_notification && !current_user?(@goal.user)
    redirect_to request.referer, notice: 'コメントを投稿しました'
  end

  private

  def set_goal
    @goal = Goal.find(params[:goal_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
