function emptyNewSongForm() {
  $("#new-song-txt-field").val("")
}

function sizeThumbnails() {
  sizeThumbnailsByClass('.playlist-thumbnail', 150);
  sizeThumbnailsByClass('.history-thumbnail', 150);
  sizeThumbnailsByClass('.liked-thumbnail', 150);
}

function updatePlayedSong(player_id) {
  $.ajax({
    url: "/players/" + player_id + "/currentsong",
    type: "GET",
    success: (json) => {
      if(json != {}) {
        $("#played_song").html("Lecture en cours : " + json.name);
      }
    }
  })
}

function sizeThumbnailsByClass(className, width) {
  while(width > $(window).width() / 3) {
    width -= 10
  }
  thumbnails = document.querySelectorAll(className)
  thumbnailArray = Array.prototype.slice.call(thumbnails);
  thumbnailArray.forEach(function (img) {
    img.width = width
  });
  activateDefaultSongList()
}

function replay(link, room_id) {
  $.ajax({
    url: "/songs/" + room_id + "?link=" + link,
    type: "POST"
  })
  activateDefaultSongList()
}

function takeLead(room_id, user_id) {
  let url = "/rooms/" + room_id + "/takelead?user_id=" + user_id
  $.ajax({
    url: "/rooms/" + room_id + "/takelead?user_id=" + user_id,
    type: "GET"
  })
}

function activateDefaultSongList() {
  $("#playlist_tab_link").addClass("active")
  $("#history_tab_link").removeClass("active")
  $("#liked_tab_link").removeClass("active")
}
