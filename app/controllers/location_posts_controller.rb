# frozen_string_literal: true

# LocationPostsController
class LocationPostsController < ApplicationController
  def index
    @posts = Post.where(place_id: params[:place_id])
  end
end
