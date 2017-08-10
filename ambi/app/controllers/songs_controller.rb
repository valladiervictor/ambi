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
      @room.update modified_at: DateTime.now.to_i
      @player.update modified_at: DateTime.now.to_i

      link = !params["song"].blank? ? parseLink(params["song"]["link"]) : params["link"]

      is_current = @player.song_id ? false : true

      video = Yt::Video.new id: link

      begin
        @song = Song.new(
          name: video.title,
          link: link,
          room_id: params["room_id"],
          poll: 1,
          thumbnail: "https://img.youtube.com/vi/#{link}/mqdefault.jpg",
          modified_at: DateTime.now.to_i,
          past: false,
          liked: false
        )
        @song.save

        if (is_current)
          @player.update song_id: @song.id
          @song.update past: true
          sync_update @player
        else
          @room.reload
          sync_update @room
        end

        respond_to do |format|
          format.json { render json: [], status: 200 }
          format.html { redirect_to @room }
        end
      rescue
        respond_to do |format|
          format.json { render status: 400 }
          format.html { redirect_to @room }
        end
      end
    end
  end

  def show
    @song = Song.find(params["id"])
  end

  def update
    @song = Song.find(params["id"])
    @room = Room.find(@song.room_id)

    if (params["poll"].blank? && params["liked"].blank? && params["past"].blank?)
      render status: 400
    end
    if (params.has_key?(:poll))
      if (session[@room.id.to_s + '/' + @song.id.to_s] != params["poll"])
        poll = params["poll"] == "minus" ? -1 : 1
        @song.update poll: @song.poll + poll
        session[@room.id.to_s + '/' + @song.id.to_s] = params["poll"]
      end
    elsif (params.has_key?(:liked))
      @song.update liked: true
    end
    @room.reload
    sync_update @room
    respond_to do |format|
      format.json { render json: [], status: 200 }
      format.html { redirect_to @room }
    end
  end

  private
    def parseLink(url)
      url.split("&").first.tr("/","=").split("=").last
    end
end
