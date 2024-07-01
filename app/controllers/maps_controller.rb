# frozen_string_literal: true

# MapsController
class MapsController < ApplicationController
  before_action :logged_in_user

  def index
    @micropost = Micropost.find_by(id: params[:micropost_id])
  end
end
