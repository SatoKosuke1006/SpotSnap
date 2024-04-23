# frozen_string_literal: true

# ApplicationController
class PasswordResetsController < ApplicationController
  before_action :get_user,         only: %i[edit update]
  before_action :valid_user,       only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'パスワードをリセットするためのメールを送信しました'
      redirect_to root_url
    else
      flash.now[:danger] = 'メールアドレスが見つかりません'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update # rubocop:disable Metrics/MethodLength
    if params[:user][:password].empty?
      @user.errors.add(:password, '入力値が空です')
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      reset_session
      log_in @user
      flash[:success] = 'パスワードがリセットされました'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # ユーザー情報の取得
  def get_user # rubocop:disable Naming/AccessorMethodName
    @user = User.find_by(email: params[:email])
  end

  # 有効なユーザーかどうか確認する
  def valid_user
    redirect_to root_url unless @user&.activated? && @user&.authenticated?(:reset, params[:id])
  end

  # トークンが期限切れかどうか確認する
  def check_expiration
    if @user.password_reset_expired? # rubocop:disable Style/GuardClause
      flash[:danger] = 'パスワードのリセットの有効期限が切れました'
      redirect_to new_password_reset_url
    end
  end
end
