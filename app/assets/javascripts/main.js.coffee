$ ->
  mapFrame = '<div id="map-frame" class="frame float-left"></div>'
<<<<<<< HEAD
  statusFrame = '<div id="status-frame" class="frame float-left"><div id="status-list"></div></div>'
=======
  statusFrame = '<div id="status-frame" class="frame float-left"></div>'
>>>>>>> f92f74ece5a889ac7852d8f8950b714c9c6c0c62
  commentsFrame = '<div id="comments-frame" class="frame float-left"></div>'

  newPost = """
    <div id="newpost">
      <div id="newpost-type" class="float-left">
        <div id="newpost-type-event" class="newpost-type">Event</div>
        <div id="newpost-type-status" class="newpost-type">Status</div>
      </div>
      <textarea id="newpost-content"></textarea>
      <div id="newpost-location-second" class="newpost-location">
        <input type="text" id="newpost-location-second-text" class="newpost-location-text float-left" />
      </div>
      <div id="newpost-location-first" class="newpost-location">
        <input type="text" id="newpost-location-first-text" class="newpost-location-text float-left" />
      </div>
      <input type="button" id="newpost-submit" class="float-right" value="Submit" />
      <div class="float-clear"></div>
    </div>"""
      

  $('#frame-container').append(mapFrame)
  $('#frame-container').append(statusFrame)
  $('#frame-container').append(commentsFrame)
  $('#status-frame').prepend(newPost)
  
  $('#slide-left').click ->
    $('#frame-container').animate({'margin-left': '-=50%'}, 'slow')

  $('#slide-right').click ->
    $('#frame-container').animate({'margin-left': '+=50%'}, 'slow')
 

  # Google maps for Tsinghua
  tsinghua = new google.maps.LatLng(40.003, 116.327)
  mapOpt = {zoom: 15, center: tsinghua, mapTypeId: google.maps.MapTypeId.ROADMAP}
  map = new google.maps.Map(document.getElementById('map-frame'), mapOpt)

  t = 0
  google.maps.event.addListener map, 'bounds_changed', ->
    # get bounds of current map
    northBound = map.getBounds().getNorthEast().lat()
    eastBound = map.getBounds().getNorthEast().lng()
    southBound = map.getBounds().getSouthWest().lat()
    westBound = map.getBounds().getSouthWest().lng()

    clearTimeout(t)
    t = setTimeout ->
      $.get '/events', (data) ->
        $('#status-list').empty()
        for event in data
           $('#status-list').append """
             <div class="status-item">
               <a href="xxx">#{event.title}</a>
               <p>#{event.content}</p>
               <span class="location">#{event.location}</span>
             </div>"""
    , 500

# vim: set ts=2 sw=2 et:

