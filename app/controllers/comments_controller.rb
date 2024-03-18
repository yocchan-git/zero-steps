class CommentsController < ApplicationController
  def destroy
    comment = current_user.comments.find(params[:id])

    comment.destroy!
    redirect_to comment.commentable, notice: 'コメントを削除しました'
  end
end
