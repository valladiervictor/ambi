class RoomsController < ApplicationController
  def create
    @room = Room.new name: params['name']
    if @room.save
      redirect_to @room
    else
      render 'pages/home'
    end
    # new_room = Room.create name: params[:name]
    # session[:display_video] = true
    # redirect_to new_room
  end

  def show
    @room = Room.find(params.require :id)
    if session[:display_video]
      @display_video = true
    else
      @display_video = false
    end
  end
end
