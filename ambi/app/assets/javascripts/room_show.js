function emptyNewSongForm() {
  $("#new-song-txt-field").val("")
}

function sizeThumbnails(width) {
  while(width > $(window).width() / 3) {
    width -= 10
  }
  thumbnails = document.querySelectorAll('.thumbnail')
  thumbnailArray = Array.prototype.slice.call(thumbnails);
  thumbnailArray.forEach(function (img) {
    img.width = width
  });
}

function replay(link, room_id) {
  $.ajax({
    url: "/songs/" + room_id + "?link=" + link,
    type: "POST"
  })

  $("#playlist_tab_link").addClass("active")
  $("#history_tab_link").removeClass("active")
}
