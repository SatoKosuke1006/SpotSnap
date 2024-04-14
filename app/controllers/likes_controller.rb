class LikesController < ApplicationController
    
  def index
    @liked_microposts = current_user.liked_microposts.includes(:user).order(created_at: :desc)
  end
  
  def create
    @micropost = Micropost.find(params[:micropost_id])
    unless @micropost.liked?(current_user)
      Like.create(user_id: current_user.id, micropost_id: @micropost.id)
    end  
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("like_buttons_#{params[:micropost_id]}",
          partial: "likes/like", 
          locals: { micropost: @micropost })
      }
    end
  end
  
  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @micropost_like = Like.find_by(user_id: current_user.id, micropost_id: @micropost.id)
    if @micropost_like
      @micropost_like.destroy
    end
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.update("like_buttons_#{params[:micropost_id]}",
          partial: "likes/like", 
          locals: { micropost: @micropost })
      }
    end
  end
end