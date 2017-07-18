class SongsController < ApplicationController
  def create
    Yt.configuration.api_key = "AIzaSyCYHhhQAawBIb0xH-xDj1Hd0j3tmnTpnxI"

    @room = Room.find(params["room_id"])
    @player = Player.find(@room.player_id)
    if (@room)
      link = params["song"]["link"].split("?t=").first
      link = link.tr("/","=").split("=").last
      if (@player.song_id)
        is_current = false
      else
        is_current = true
      end
      video = Yt::Video.new id: link
      if !video
        respond_to do |format|
          format.json { render status: 400 }
          format.html { redirect_to @room }
        end
      end
      thumbnail = "https://img.youtube.com/vi/#{link}/mqdefault.jpg"
      @song = Song.new(
        name: video.title,
        link: link,
        room_id: is_current ? nil : params["room_id"],
        poll: 1,
        thumbnail: thumbnail
      )
      @song.save
      if (is_current)
        @player.update song_id: @song.id
        sync_update @player
      else
        @room.reload
        sync_update @room
      end
      respond_to do |format|
        format.json { render json: [], status: 200 }
        format.html { redirect_to @room }
      end
    else
    respond_to do |format|
      format.json { render status: 400 }
      format.html { redirect_to "/pages/home" }
    end
    end
  end

  def show
    @song = Song.find(params["id"])
  end

  def update
    @song = Song.find(params["id"])
    @room = Room.find(@song.room_id)

    if (params["poll"].blank?)
      render status: 400
    end
    if (session[@room.id.to_s + '/' + @song.id.to_s] != params["poll"])
      poll = params["poll"] == "minus" ? -1 : 1
      @song.update poll: @song.poll + poll
      session[@room.id.to_s + '/' + @song.id.to_s] = params["poll"]
    end
    @room.reload
    sync_update @room
    render status: 200
  end
end
