# frozen_string_literal: true

# LocationPostsController
class LocationPostsController < ApplicationController
  def index
    lat_range = params[:lat].to_f - 0.001..params[:lat].to_f + 0.001
    lng_range = params[:lng].to_f - 0.001..params[:lng].to_f + 0.001
    @microposts = Micropost.where(lat: lat_range, lng: lng_range)
    @place_name = params[:name]
  end

  def count
    lat_range = params[:lat].to_f - 0.001..params[:lat].to_f + 0.001
    lng_range = params[:lng].to_f - 0.001..params[:lng].to_f + 0.001
    count = Micropost.where(lat: lat_range, lng: lng_range).count
    render json: { count: count }
  end
end
