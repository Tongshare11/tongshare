$ ->
  $('#header').prepend('<h1>Tongshare</h1>')
  $('#footer').prepend('<h3>Bravura</h3>')

  mapFrame = '
    <div id="map-frame" class="frame">
      <p>Google maps for tsinghua</p>
    </div>'

  statusFrame = '
    <div id="status-frame" class="frame">
      <ul>
        <li>status 1</li>
        <li>status 2</li>
        <li>event 1</li>
      </ul>
    </div>'
  
  commentsFrame = '
    <div id="comments-frame" class="frame">
      <ul>
        <li>comment 1</li>
        <li>comment 2</li>
      </ul>
    </div>'

  cntFrame = 0

  initPage = ->
    cntFrame = 0
    $("#left-frame").html(mapFrame)
    $("#right-frame").html(statusFrame)

  $("#frame-slide-left").click(
    ->
      if cntFrame is 1
        $("#left-frame").html(mapFrame)
        $("#right-frame").html(statusFrame)
        cntFrame = 0
  )
  $("#frame-slide-right").click(
    ->
      if cntFrame is 0
        $("#left-frame").html(statusFrame)
        $("#right-frame").html(commentsFrame)
        cntFrame = 1
  )

  initPage()

