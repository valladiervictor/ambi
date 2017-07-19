class SongsController < ApplicationController
  def create
    Yt.configuration.api_key = "AIzaSyCYHhhQAawBIb0xH-xDj1Hd0j3tmnTpnxI"

    @room = Room.find(params["room_id"])
    if (!@room)
      respond_to do |format|
        format.json { render status: 400 }
        format.html { redirect_to "/pages/home" }
      end
    else
      @player = Player.find(@room.player_id)
      @room.update modified_at: DateTime.now
      @player.update modified_at: DateTime.now

      link = parseLink(params["song"]["link"])

      is_current = @player.song_id ? false : true

      video = Yt::Video.new id: link
      if !video
        respond_to do |format|
          format.json { render status: 400 }
          format.html { redirect_to @room }
        end
      end

      @song = Song.new(
        name: video.title,
        link: link,
        room_id: is_current ? nil : params["room_id"],
        poll: 1,
        thumbnail: "https://img.youtube.com/vi/#{link}/mqdefault.jpg",
        modified_at: DateTime.now
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

  private
    def parseLink(url)
      url.split("?t=").first.tr("/","=").split("=").last
    end
end
