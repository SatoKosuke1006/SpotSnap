# frozen_string_literal: true

# StaticPagesController
class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def home
    if logged_in? # rubocop:disable Style/GuardClause
      @micropost  = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
    end
  end
end
