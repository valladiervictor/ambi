class PlayersController < ApplicationController
  def current_song

    @player = Player.find(params["player_id"])
    @current_song = Song.find(@player.song_id)
    if @current_song
      render json: @current_song.to_json, status: 200
    else
      render json: {}, status: 200
    end
  end
end
