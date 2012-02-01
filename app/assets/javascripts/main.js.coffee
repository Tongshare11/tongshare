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
          <input type="text" id="newpost-location-first-text" class="round-input-text newpost-location-text" autocomplete="off">
          <div id="newpost-location-first-list"></div>
        </div>
        <div id="newpost-location-second" class="newpost-location float-left">
          <input type="text" id="newpost-location-second-text" class="round-input-text newpost-location-text">
          <div id="newpost-location-second-list"></div>
        </div>
        <div id="newpost-custom-location" class="text-button float-left">No location?</div>
        <input type="button" id="newpost-submit" class="float-right" value="Submit">
      </div>
      <div class="float-clear"></div>
    </div>"""
      

  $('#frame-container').append(mapFrame)
  $('#frame-container').append(statusFrame)
  $('#frame-container').append(commentsFrame)
  $('#status-frame').prepend(newPost)
  
  $('#slide-left').click ->
    $('#frame-container').animate({'margin-left': '+=50%'}, 'slow')

  $('#slide-right').click ->
    $('#frame-container').animate({'margin-left': '-=50%'}, 'slow')

  # User
  visitor = """
    E-mail <input type="text" id="email-text" class="round-input-text">
    Password <input type="password" id="password-text" class="round-input-text">
    <input type="button" value="Sign in" id="login">
    <input type="button" value="Sign up" id="register">"""
  $('#user-login').append(visitor)


  # Google maps for Tsinghua
  tsinghua = new google.maps.LatLng(40.003, 116.327)
  mapOpt = {zoom: 15, center: tsinghua, mapTypeId: google.maps.MapTypeId.ROADMAP}
  map = new google.maps.Map(document.getElementById('map-frame'), mapOpt)

  # Show status' locations on maps
  statusMarkers = []
  showMarkers = ->
    for marker in statusMarkers
      marker.setMap(null)
    statusMarkers = []
    for event in statusList
      lat = parseFloat(event.latitude)
      lng = parseFloat(event.longitude)
      marker = new google.maps.Marker
        position: new google.maps.LatLng(lat, lng)
        map: map
        draggable: false
      statusMarkers.push(marker)

  # Update status list
  statusList = []
  updateStatusList = ->
    $.get '/events', (data) ->
      $('#status-list').empty()
      statusList = data
      iter = 0
      for event in data
        $('#status-list').prepend """
          <div class="status-item" id="#{iter}">
            <a href="xxx">Cysu</a>
            <p>#{event.content}</p>
            <span class="location">#{event.first + ' - ' + event.second}</span>
          </div>"""
        iter += 1
      showMarkers()
      # Emphasize the hover status
      $('.status-item').hover ->
        for marker in statusMarkers
          marker.setAnimation(null)
        i = parseInt($(this).attr('id'))
        statusMarkers[i].setAnimation(google.maps.Animation.BOUNCE)

  updateDelay = 0
  google.maps.event.addListener map, 'bounds_changed', ->
    # get bounds of current map
    northBound = map.getBounds().getNorthEast().lat()
    eastBound = map.getBounds().getNorthEast().lng()
    southBound = map.getBounds().getSouthWest().lat()
    westBound = map.getBounds().getSouthWest().lng()

    # update the status list
    clearTimeout(updateDelay)
    updateDelay = setTimeout ->
      updateStatusList()
    , 500


  # ###########################
  # Newpost Module
  # ###########################
  newpostMarker = new google.maps.Marker
    position: new google.maps.LatLng(0, 0)
    map: null
    draggable: true
  google.maps.event.addListener newpostMarker, 'drag', ->
    $('#newpost-location-first-text').val('')
    $('#newpost-location-second-text').val('')
    newpostMarker.setTitle('Your Location')

  calcRel = (key, loc) ->
    if key == loc.title
      return 1
    if loc.title.indexOf(key) != -1
      return 0.99
    ret = 0
    for i in [0..key.length-1]
      if loc.title.indexOf(key.charAt(i)) != -1
        ret += 1
    return ret * 1.0 / key.length

  # Function to get suggested locations by a given key string.
  getSugLocs = (locs, key) ->
    r = []
    for loc in locs
      r.push({loc:loc, rel:calcRel(key, loc)})
    comp = (a, b) ->
      if a.rel > b.rel
        return -1
      else if a.rel == b.rel
        return 0
      else if a.rel < b.rel
        return 1
    r.sort(comp)
    ret = []
    for i in [0..Math.min(4, r.length-1)]
      ret.push(r[i].loc)
    return ret

  # Funtion to select a suggested location
  selectSugLoc = (i) ->
    return if i < 0
    loc = cntSugLocs[i]
    $('#newpost-location-first-text').val(loc.title)
    latlng = new google.maps.LatLng(loc.latitude, loc.longitude)
    newpostMarker.setPosition(latlng)
    newpostMarker.setMap(map)
    newpostMarker.setTitle(loc.title)
    $('#newpost-location-first-list').fadeOut()
    clearInterval(updateSugLocsInterval)
    $('#newpost-location-second-text').focus()

  # Funtion to update the suggested location list
  prevKey = null
  cntSugLocs = null
  updateSugLocs = ->
    key = $('#newpost-location-first-text').val()
    if prevKey == null or prevKey != key
      prevKey = key
      cntSugLocs = getSugLocs(totLocs, key)
      code = ''
      for i in [0..cntSugLocs.length-1]
        code += """<div class="newpost-location-listitem" id="#{i}">#{cntSugLocs[i].title}</div>"""
    $('#newpost-location-first-list').html(code)
    $('#newpost-location-first-list').fadeIn('fast')
    $('.newpost-location-listitem').click ->
      i = parseInt $(this).attr('id')
      selectSugLoc(i)
      
  # get location first list
  totLocs = []
  $.get '/points.json', (data) ->
    totLocs = data

  $('#newpost-extend-bottom').hide()
  $('#newpost-location-first-list').hide()
  $('#newpost-location-second-list').hide()

  $('#newpost').click ->
    $('#newpost-extend-bottom').fadeIn('fast')

  updateSugLocsInterval = null
  $('#newpost-location-first-text').focusin ->
    if (updateSugLocsInterval != null)
      clearInterval(updateSugLocsInterval)
    updateSugLocsInterval = setInterval(updateSugLocs, 1000)

  $('#newpost-location-first-text').blur ->
    $('#newpost-location-first-list').fadeOut()
    clearInterval(updateSugLocsInterval)

  cntSelSugLoc = -1
  $('#newpost-location-first-text').keyup (event) ->
    if event.which == 13
      selectSugLoc(cntSelSugLoc)
      return
    else if event.which == 38
      cntSelSugLoc -= 1
      if cntSelSugLoc < 0
        cntSelSugLoc = cntSugLocs.length - 1
    else if event.which == 40
      cntSelSugLoc += 1
      if cntSelSugLoc >= cntSugLocs.length
        cntSelSugLoc = 0
    else
      cntSelSugLoc = -1
    $('.newpost-location-listitem').css('background-color', '#fff')
    if cntSelSugLoc != -1
      $('#'+cntSelSugLoc).css('background-color', '#ddd')

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
    
    

