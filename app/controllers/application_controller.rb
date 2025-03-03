# frozen_string_literal: true

# ApplicationController
class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  # ユーザーのログインを確認する
  def logged_in_user
    unless logged_in? # rubocop:disable Style/GuardClause
      store_location
      flash[:danger] = 'ログインしてください'
      redirect_to login_url, status: :see_other
    end
  end
end
