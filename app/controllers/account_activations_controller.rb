# frozen_string_literal: true

# ApplicationController
class AccountActivationsController < ApplicationController
  def edit # rubocop:disable Metrics/AbcSize
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'アカウントが有効になりました'
      redirect_to home_url
    else
      flash[:danger] = '無効なリンクです'
      redirect_to root_url
    end
  end
end
