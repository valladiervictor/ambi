function emptyNewSongForm() {
  $("#new-song-txt-field").val("")
}

function sizeThumbnails() {
  sizeThumbnailsByClass('.playlist-thumbnail', 150);
  sizeThumbnailsByClass('.history-thumbnail', 150);
  sizeThumbnailsByClass('.liked-thumbnail', 150);
}

function displayPlaylist() {
  $("#table-history").css("display", "none");
  $("#table-liked").css("display", "none");
  $("#table-playlist").css("display", "block");
  $("#playlist_tab_link").addClass("active");
  $("#history_tab_link").removeClass("active");
  $("#liked_tab_link").removeClass("active");
}
function displayLiked() {
  $("#table-history").css("display", "none");
  $("#table-playlist").css("display", "none");
  $("#table-liked").css("display", "block");
}
function displayHistory() {
  $("#table-playlist").css("display", "none");
  $("#table-liked").css("display", "none");
  $("#table-history").css("display", "block");
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
  displayPlaylist();
}

function replay(link, room_id) {
  $.ajax({
    url: "/songs/" + room_id + "?link=" + link,
    type: "POST"
  })
  activateDefaultSongList();
  displayPlaylist();
}

function takeLead(room_id, user_id) {
  let url = "/rooms/" + room_id + "/takelead?user_id=" + user_id
  $.ajax({
    url: "/rooms/" + room_id + "/takelead?user_id=" + user_id,
    type: "GET"
  })
}
