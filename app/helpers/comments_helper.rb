# frozen_string_literal: true

module CommentsHelper
  def recent_comments(resource, comment_count:)
    resource.comments.preload(:user, :commentable).order(created_at: :desc).limit(comment_count)
  end

  def link_text(comments)
    comments.empty? ? 'コメント受付中' : 'もっと見る'
  end

  def comment_index_url(commentable)
    commentable.instance_of?(Goal) ? goal_comments_path(commentable) : task_comments_path(commentable)
  end
end
