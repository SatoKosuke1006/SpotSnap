# frozen_string_literal: true

# StaticPagesController
class StaticPagesController < ApplicationController
  before_action :logged_in_user

  def home
    if logged_in?
      @micropost  = current_user.microposts.build
      if params[:filter] == 'following'
        @feed_items = current_user.following_feed.paginate(page: params[:page], per_page: 10)
      else
        @feed_items = Micropost.all.paginate(page: params[:page], per_page: 10)
      end
    end
  end

  def how_to_use
  end
end
