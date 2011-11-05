$ ->
  $('#header').prepend('<h1>Tongshare</h1>')
  $('#footer').prepend('<h3>Bravura</h3>')

  mapFrame = '
    <div id="map-frame" class="frame float-left">
      <p>Google maps for tsinghua</p>
    </div>'

  statusFrame = '
    <div id="status-frame" class="frame float-left">
      <ul>
        <li>status 1</li>
        <li>status 2</li>
        <li>event 1</li>
      </ul>
    </div>'
  
  commentsFrame = '
    <div id="comments-frame" class="frame float-left">
      <ul>
        <li>comment 1</li>
        <li>comment 2</li>
      </ul>
    </div>'

  $('#frame-container').append(mapFrame)
  $('#frame-container').append(statusFrame)
  $('#frame-container').append(commentsFrame)
  
  $('#frame-slide-left').click(
    ->
      $('#frame-container').animate({'margin-left': '-=400px'}, 'slow')
  )

  $('#frame-slide-right').click(
    ->
      $('#frame-container').animate({'margin-left': '+=400px'}, 'slow')
  )

