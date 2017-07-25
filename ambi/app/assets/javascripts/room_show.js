function emptyNewSongForm() {
  $("#new-song-txt-field").val("")
}

function sizeThumbnails() {
  width = 200
  while(width > $(window).width() / 3) {
    width -= 10
  }
  thumbnails = document.querySelectorAll('.thumbnail')
  thumbnailArray = Array.prototype.slice.call(thumbnails);
  thumbnailArray.forEach(function (img) {
    img.width = width
  });
}
