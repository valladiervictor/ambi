class RoomsController < ApplicationController
  def create
    @player = Player.create
    @room = Room.new name: params["room"]["name"], player_id: @player.id
    randomize_id
    if @room.save
      @player.update room_id: @room.id
      session[:display_video] = true
      redirect_to @room
    else
      render 'pages/home'
    end
  end

  def show
    @room = Room.find(params["id"])
    @player = Player.find(@room.player_id)
    if !session[:display_video].blank?
      @display_video = true
    else
      @display_video = false
    end
  end

  def join
    @room = Room.find_by(name: params["name"])
    if !@room.blank?
      session[:display_video] = false
      redirect_to @room
    else
      redirect_to controller: 'pages', action: 'home', session_joining_error: 'Pas de session à ce nom'
    end
  end

  def next
    @room = Room.find(params["room_id"])
    if !@room
      render status: 400
    end
    @player = Player.find(@room.player_id)
    Song.find(@player.song_id).destroy!
    if @room.songs.any?
      new_song = @room.songs.order("poll DESC").first
      new_song.update room_id: nil
      @player.update song_id: new_song.id
      sync_update @room
      render json: new_song.to_json, status: 200
    else
      @player.update song_id: nil
      render json: [], status: 200
    end
  end

  private
  def randomize_id
    begin
      @room.id = SecureRandom.random_number(1_000_000)
    end while Room.where(id: @room.id).exists?
  end
end
