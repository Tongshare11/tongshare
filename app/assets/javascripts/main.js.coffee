$ ->
  mapFrame = '<div id="map-frame" class="frame float-left"></div>'
  statusFrame = '<div id="status-frame" class="frame float-left"></div>'  
  commentsFrame = '<div id="comments-frame" class="frame float-left"></div>'

  $('#frame-container').append(mapFrame)
  $('#frame-container').append(statusFrame)
  $('#frame-container').append(commentsFrame)
  
  $('#slide-left').click(
    ->
      $('#frame-container').animate({'margin-left': '-=50%'}, 'slow')
  )

  $('#slide-right').click(
    ->
      $('#frame-container').animate({'margin-left': '+=50%'}, 'slow')
  )

  # Google maps for Tsinghua
  tsinghua = new google.maps.LatLng(40.003, 116.327)
  mapOpt = {zoom: 15, center: tsinghua, mapTypeId: google.maps.MapTypeId.ROADMAP}
  map = new google.maps.Map(document.getElementById('map-frame'), mapOpt)

  # get bounds of current map
  google.maps.event.addListener(map, 'bounds_changed',
    ->
      northBound = map.getBounds().getNorthEast().lat()
      eastBound = map.getBounds().getNorthEast().lng()
      southBound = map.getBounds().getSouthWest().lat()
      westBound = map.getBounds().getSouthWest().lng()


      $('#status-frame').html('
        <div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div>
        <div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div><div class="status-item">
          <a href="xx">username</a>
          <p>mesage</p>
          <span class="location">location</span>
        </div>
      ')
  )


  
