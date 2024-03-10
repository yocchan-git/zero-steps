class RelationshipsController < ApplicationController
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)

    @is_users_page = params[:is_users_page]
    redirect_uri = @is_users_page ? users_path : @user

    respond_to do |format|
      format.html { redirect_to redirect_uri }
      format.turbo_stream
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)

    @is_users_page = params[:is_users_page]
    redirect_uri = @is_users_page ? users_path : @user

    respond_to do |format|
      format.html { redirect_to redirect_uri, status: :see_other }
      format.turbo_stream
    end
  end
end
