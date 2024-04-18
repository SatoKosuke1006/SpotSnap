class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def show
    @micropost = Micropost.find(params[:id])
  end
  
  def new
    @micropost = Micropost.new
  end  

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "投稿されました"
      redirect_to home_path, status: :see_other
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'microposts/new', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました"
    if request.referrer == micropost_url(@micropost)
      redirect_to user_path(@micropost.user)
    else
      redirect_back(fallback_location: home_url)
    end
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image, :lat, :lng)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
