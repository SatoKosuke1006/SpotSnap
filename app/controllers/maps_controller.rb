class MapsController < ApplicationController
  def index
    @micropost = Micropost.find_by(id: params[:micropost_id])
  end
end
