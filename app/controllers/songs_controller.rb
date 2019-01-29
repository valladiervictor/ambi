class SongsController < ApplicationController
  def create
    Yt.configuration.api_key = "AIzaSyCYHhhQAawBIb0xH-xDj1Hd0j3tmnTpnxI"

    @room = Room.find(params["room_id"])
    if (!@room)
      respond_to do |format|
        format.json { render json: { error: 'missing room id' }, status: 400 }
        format.html { redirect_to "/pages/home" }
      end
    else
      @player = Player.find(@room.player_id)
      @room.update modified_at: DateTime.now.to_i
      @player.update modified_at: DateTime.now.to_i

      link = !params["song"].blank? ? parseLink(params["song"]["link"]) : params["link"]
      isPlaylist = !params["song"].blank? ? parseLink(params["song"]["playlist"]) : params["playlist"]

      is_current = @player.song_id ? false : true


      begin
        puts "------------------------------------------------------------------------"
        puts params
        if (isPlaylist == "false")
          addVideoFromLink(link)
        else
          addAllVideosFromPlaylist(link)
        end

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
      rescue Exception => e
        puts e
        respond_to do |format|
          format.json { render json: { error: e }, status: 400 }
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
    if (params.has_key?(:poll))   # Incoming vote in the playlist
      if (session[@room.id.to_s + '/' + @song.id.to_s] != params["poll"])
        poll = params["poll"] == "minus" ? -1 : 1
        @song.update poll: @song.poll + poll
        session[@room.id.to_s + '/' + @song.id.to_s] = params["poll"]
      end
    elsif (params.has_key?(:liked))   # New liked song
      @song.update liked: true
    end
    @room.reload
    sync_update @room
    respond_to do |format|
      format.json { render json: [], status: 200 }
      format.html { redirect_to @room }
    end
  end
  def addVideoFromLink(youtubeId, priority = 1)
    video = Yt::Video.new id: youtubeId
    @song = Song.new(
      name: video.title,
      link: youtubeId,
      room_id: params["room_id"],
      poll: priority,
      thumbnail: "https://img.youtube.com/vi/#{youtubeId}/mqdefault.jpg",
      modified_at: DateTime.now.to_i,
      past: false,
      liked: false
    )
    @song.save
  end

  private
    def parseLink(url)
      url.split("&").first.tr("/","=").split("=").last
    end
    def addAllVideosFromPlaylist(link)
      playlist = Yt::Playlist.new id: link
      playlist.playlist_items.each do |pit|
        addVideoFromLink(pit.video_id, 0)
      end

    end
end
