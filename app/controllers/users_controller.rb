# frozen_string_literal: true

# ApplicationController
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index show edit update destroy following followers]
  before_action :correct_user,   only: %i[edit update]
  before_action :admin_user,     only: :destroy

  def index
    @users = if params[:search].present?
               User.where('name LIKE ?', "%#{params[:search]}%").paginate(page: params[:page], per_page: 10)
             else
              User.paginate(page: params[:page], per_page: 10)
             end
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page], per_page: 45)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'アカウントを有効にするには、メールを確認してください'
      redirect_to root_url
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'プロフィールを更新しました'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'アカウントを削除しました'
    redirect_to users_url, status: :see_other
  end

  def following
    @title = 'フォロー中'
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー'
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page], per_page: 10)
    render 'show_follow'
  end

  private

  # 送信可能なパラメータか確認する
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # 正しいユーザーかどうかを確認
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless current_user?(@user)
  end

  # 管理者かどうかを確認
  def admin_user
    redirect_to(root_url, status: :see_other) unless current_user.admin?
  end
end
