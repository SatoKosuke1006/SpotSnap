class LikesController < ApplicationController
    
  def index
    @liked_microposts = current_user.liked_microposts.includes(:user).order(created_at: :desc)
  end
  
  def create
    @micropost_like = Like.new(user_id: current_user.id, micropost_id: params[:micropost_id])
    @micropost_like.save
    redirect_to @micropost_like.micropost
  end
  
  def destroy
    @micropost_like = Like.find_by(user_id: current_user.id, micropost_id: params[:micropost_id])
    @micropost_like.destroy
    redirect_to @micropost_like.micropost
  end
end