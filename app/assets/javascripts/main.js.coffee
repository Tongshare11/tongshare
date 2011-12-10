$ ->
  mapFrame = '<div id="map-frame" class="frame float-left"></div>'
  statusFrame = '<div id="status-frame" class="frame float-left"><div id="status-list"></div></div>'
  commentsFrame = '<div id="comments-frame" class="frame float-left"></div>'

  newPost = """
    <div id="newpost">
      <h2>New post</h2>
      <div id="newpost-type" class="float-left">
        <div id="newpost-type-event" class="newpost-type">Event</div>
        <div id="newpost-type-status" class="newpost-type">Status</div>
      </div>
      <textarea id="newpost-content"></textarea>
      <div id="newpost-extend-bottom">
        <h3 class="float-left">Location</h3>
        <div id="newpost-location-first" class="newpost-location float-left">
          <input type="text" id="newpost-location-first-text" class="newpost-location-text" />
          <div id="newpost-location-first-list"></div>
        </div>
        <div id="newpost-location-second" class="newpost-location float-left">
          <input type="text" id="newpost-location-second-text" class="newpost-location-text" />
          <div id="newpost-location-second-list"></div>
        </div>
        <input type="button" id="newpost-submit" class="float-right" value="Submit" />
      </div>
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

    # update the status list
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

  # Newpost
  $('#newpost-extend-bottom').hide()
  $('#newpost').click ->
    $('#newpost-extend-bottom').fadeIn('fast')
  $('#newpost-location-first-text').focusin ->
    # TODO get locs
    locs = """
      <div class="newpost-location-listitem">Tsinghua</div>
      <div class="newpost-location-listitem">University</div>"""
    $('#newpost-location-first-list').html(locs)
  $('#newpost-location-first-text').blur ->
    $('#newpost-location-first-list').empty()

  $('#newpost-submit').click ->
    content = $('#newpost-content').val()
    # TODO
    lat = map.getCenter().lat()
    lng = map.getCenter().lng()
    locationFirst = $('#newpost-location-first-text').val()
    locationSecond = $('#newpost-location-second-text').val()
    $.ajax
      type: 'POST'
      url: '/events'
      data: JSON.stringify({content: content, latitude: lat, longitude: lng, first: locationFirst, second: locationSecond})
      contentType: 'application/json'
      success: (response) ->
        alert(response)
    
    

