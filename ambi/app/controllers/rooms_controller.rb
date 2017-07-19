class RoomsController < ApplicationController
  def create
    remove_old_data
    @player = Player.create modified_at: DateTime.now
    @room = Room.new name: params["room"]["name"], player_id: @player.id, modified_at: DateTime.now
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
      if params["display_video"].blank?
        session[:display_video] = false
      else
        session[:display_video] = params["display_video"] == "true"
      end
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
    if !@player.song_id
      render json: [], status: 200
    else
      current_song = Song.find(@player.song_id)
      if current_song.id.to_s != params["current_song_id"]
        respond_to do |format|
          format.json { render json: [], status: 200 }
          format.html { redirect_to @room }
        end
      else
        current_song.destroy!
        if @room.songs.any?
          new_song = @room.songs.order("poll DESC").first
          new_song.update room_id: nil
          @player.update song_id: new_song.id
          @room.reload
          sync_update @room
          # sync_update @player

          respond_to do |format|
            format.json { render json: new_song.to_json, status: 200 }
            format.html { redirect_to @room }
          end
        else
          @player.update song_id: nil
          respond_to do |format|
            format.json { render json: [], status: 200 }
            format.html { redirect_to @room }
          end
        end
      end
    end
  end

  private
  def remove_old_data
    Room.where('modified_at < ?', 1.days.ago).each do |model|
      model.destroy
    end
    Song.where('modified_at < ?', 1.days.ago).each do |model|
      model.destroy
    end
    Player.where('modified_at < ?', 1.days.ago).each do |model|
      model.destroy
    end
  end
  def randomize_id
    begin
      @room.id = SecureRandom.random_number(1_000_000)
    end while Room.where(id: @room.id).exists?
  end
end
