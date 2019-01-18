function doMinus(song_id) {
  $.ajax({
    url: "/songs/" + song_id + "?poll=minus",
    type: "PATCH"
  })
}

function doPlus(song_id) {
  $.ajax({
    url: "/songs/" + song_id + "?poll=plus",
    type: "PATCH"
  })
}
