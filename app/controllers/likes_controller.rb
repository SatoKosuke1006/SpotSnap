# frozen_string_literal: true

# ApplicationController
class LikesController < ApplicationController
  before_action :logged_in_user

  def index
    @liked_microposts = current_user.liked_microposts.includes(:user).order(created_at: :desc)
  end

  def create
    @micropost = Micropost.find(params[:micropost_id])
    Like.create(user_id: current_user.id, micropost_id: @micropost.id) 
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("like_buttons_#{params[:micropost_id]}",
                                                 partial: 'likes/like', locals: { micropost: @micropost })
      end
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @micropost_like = Like.find_by(user_id: current_user.id, micropost_id: @micropost.id)
    @micropost_like&.destroy
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update("like_buttons_#{params[:micropost_id]}",
                                                 partial: 'likes/like', locals: { micropost: @micropost })
      end
    end
  end
end
