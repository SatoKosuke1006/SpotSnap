# frozen_string_literal: true

# MicropostsController
class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user,   only: :destroy

  def show
    @micropost = Micropost.find(params[:id])
  end

  def new
    @micropost = Micropost.new
  end

  def create # rubocop:disable Metrics/AbcSize
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = '投稿されました'
      redirect_to home_path, status: :see_other
    else
      @feed_items = current_user.feed
      render 'microposts/new', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = '投稿を削除しました'
    if request.referrer == micropost_url(@micropost)
      redirect_to user_path(@micropost.user)
    else
      redirect_back(fallback_location: root_url)
    end
  end

  private

  # パラメータの制限
  def micropost_params
    params.require(:micropost).permit(:content, :image, :place_id)
  end

  # 投稿したユーザーか確認
  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url, status: :see_other if @micropost.nil?
  end
end
