# frozen_string_literal: true

# ApplicationController
class SessionsController < ApplicationController
  def new
  end

  def create # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      if user.activated?
        session[:forwarding_url]
        reset_session
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        log_in user
        redirect_to home_url
      else
        message  = 'アカウントがアクティブ化されていません '
        message += 'メールでアクティベーションリンクを確認してください'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスかパスワードが違います'
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url, status: :see_other
  end
end

