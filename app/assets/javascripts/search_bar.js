function autocomplete(search_bar_id) {
  jQuery(search_bar_id).autocomplete({
    source: function( request, response ) {
      var sqValue = [];
      jQuery.ajax({
        type: "POST",
        url: "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1",
        dataType: 'jsonp',
        data: jQuery.extend({
        q: request.term
        }, { }),
        success: function(data){
          obj = data[1];
          jQuery.each( obj, function( key, value ) {
            sqValue.push(value[0]);
          });
          response( sqValue);
        }
      });
    },
    select: function( event, ui ) {
    setTimeout( function () {
    youtubeApiCall();
    }, 300);
  },
  appendTo: '#search-container'
  });
}

function youtubeApiCall() {
  $.ajax({
    cache: false,
    data: $.extend({
      key: 'AIzaSyCYHhhQAawBIb0xH-xDj1Hd0j3tmnTpnxI',
      q: $('#hyv-search').val(),
      part: 'snippet'
    }, {maxResults:5}),
    dataType: 'json',
    type: 'GET',
    timeout: 5000,
    url: 'https://www.googleapis.com/youtube/v3/search'
  })
  .done(function(data) {
    $('.btn-group').show();
    const items = data.items;
    const searchResults = document.querySelector("#hyv-watch-related")

    for (const item of items) {
      const searchResult = document.importNode(
        document.querySelector('#searchResult').content.firstElementChild,
        true
      );

      if (item.id.kind === 'youtube#playlist') {
        console.log({ searchResult })
        searchResult.dataset.youtubeId = item.id.playlistId;
        searchResult.addEventListener('click', addYouTubePlaylist);
      } else {
        searchResult.dataset.youtubeId = item.id.videoId;
        searchResult.addEventListener('click', addYouTubeVideo);
      }

      const thumbnail = searchResult.querySelector('.search-result-thumbnail');
      thumbnail.alt = item.snippet.title;
      thumbnail.src = item.snippet.thumbnails.default.url;
      const title = searchResult.querySelector('.search-result-title');
      title.innerHTML = item.snippet.title;

      searchResults.appendChild(searchResult);
    }
  });
}

function addYouTubePlaylist(event) {
  console.log('add yt playlist')
  const { youtubeId, roomId } = event.target.dataset;
  fetchPlaylistItems(youtubeId, roomId);
}

function addYouTubeVideo(event) {
  const { youtubeId, roomId } = event.target.dataset;
  replay(youtubeId, roomId);
}

