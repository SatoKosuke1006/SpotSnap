# frozen_string_literal: true

# LocationPostsController
class LocationPostsController < ApplicationController
  before_action :logged_in_user

  def index
    @microposts = Micropost.where(place_id: params[:place_id]).paginate(page: params[:page], per_page: 45)
    @place_name = params[:name]
    @place_formatted_address = params[:formatted_address]
  end

  def count
    count = Micropost.where(place_id: params[:place_id]).count
    render json: { count: count }
  end
end
