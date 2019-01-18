class PagesController < ApplicationController
  def home
    @room = Room.new
    @session_joining_error = params[:session_joining_error]
  end
end
