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
        <div id="newpost-custom-location" class="text-button float-left">No location?</div>
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

  updateStatusList = ->
    $.get '/events', (data) ->
      $('#status-list').empty()
      for event in data
         $('#status-list').prepend """
           <div class="status-item">
             <a href="xxx">Cysu</a>
             <p>#{event.content}</p>
             <span class="location">#{event.first + ' - ' + event.second}</span>
           </div>"""

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
      updateStatusList()
    , 500

  # Newpost
  newpostMarker = new google.maps.Marker
    position: new google.maps.LatLng(0, 0)
    map: null
    draggable: true
  google.maps.event.addListener newpostMarker, 'drag', ->
    $('#newpost-location-first-text').val('')
    $('#newpost-location-second-text').val('')
    newpostMarker.setTitle('Your Location')


  

  # get location first list
  locs = []
  $.get '/points.json', (data) ->
    locs = data

  $('#newpost-extend-bottom').hide()
  $('#newpost-location-first-list').hide()
  $('#newpost-location-second-list').hide()

  $('#newpost').click ->
    $('#newpost-extend-bottom').fadeIn('fast')

  $('#newpost-location-first-text').focusin ->
    # TODO get locs
    code = ''
    iter = 0
    for loc in locs
      code += """<div class="newpost-location-listitem" id="#{iter}">#{loc.title}</div>"""
      iter += 1
    $('#newpost-location-first-list').html(code)
    $('#newpost-location-first-list').fadeIn('fast')
    $('.newpost-location-listitem').click ->
      newpostLocTitle = $(this).html()
      $('#newpost-location-first-text').val(newpostLocTitle)
      i = parseInt $(this).attr("id")
      newpostLat = parseFloat(locs[i].latitude)
      newpostLng = parseFloat(locs[i].longitude)
      latlng = new google.maps.LatLng(newpostLat, newpostLng)
      newpostMarker.setPosition(latlng)
      newpostMarker.setMap(map)
      newpostMarker.setTitle(newpostLocTitle)

  $('#newpost-location-first-text').blur ->
    $('#newpost-location-first-list').fadeOut()

  # custom location
  $('#newpost-custom-location').click ->
    $('#newpost-location-first-text').val('')
    $('#newpost-location-second-text').val('')
    newpostMarker.setPosition(map.getCenter())
    newpostMarker.setMap(map)
    newpostMarker.setTitle('Your Location')


  $('#newpost-submit').click ->
    content = $('#newpost-content').val()
    newpostLat = newpostMarker.getPosition().lat()
    newpostLng = newpostMarker.getPosition().lng()
    locationFirst = $('#newpost-location-first-text').val()
    locationSecond = $('#newpost-location-second-text').val()
    # Judge if valid
    if content == '' or newpostLat == 0 or newpostLng == 0 or locationFirst == ''
      alert('Please say something and select a location!')
      return
    $.ajax
      type: 'POST'
      url: '/events'
      data: JSON.stringify({content: content, latitude: newpostLat, longitude: newpostLng, first: locationFirst, second: locationSecond})
      contentType: 'application/json'
      success: (response) ->
        updateStatusList()
    
    

