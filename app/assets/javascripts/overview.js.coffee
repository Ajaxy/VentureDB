renderDirections = ->
  $circlesRow = $(".directions .circles")
  return if $circlesRow.length == 0

  $circles    = $circlesRow.find(".circle")

  maxRadius   = 60
  minRadius   = 25

  backgrounds = ["9ba2ce", "b7554a", "ebb94a", "a9c48f", "2151a1", "bd6bc0"]

  width = 100 / $circles.length
  $circlesRow.find("> a").css("width": "#{width}%")

  maxAmount = $circles.first().data("amount")

  $circles.each (index) ->
    $circle = $(this)

    radius = Math.sqrt($circle.data("amount") / maxAmount) * maxRadius
    radius = minRadius if radius < minRadius

    color = backgrounds[index % backgrounds.length]

    $circle.css
      "border-radius"     : "#{radius}px"
      "height"            : "#{radius*2}px"
      "width"             : "#{radius*2}px"
      "line-height"       : "#{radius*2}px"
      "background-color"  : "##{color}"

renderDirectionsRounds = ->
  $table = $("#directions-by-rounds")
  return if $table.length == 0

  maxRadius   = 11.5
  minRadius   = 4

  maxOpacity  = 1
  minOpacity  = 0.25

  avgRadius   = (maxRadius + minRadius) / 2
  avgOpacity  = (maxOpacity + minOpacity) / 2

  avgAmount   = $table.data("values").average_amount
  avgCount    = $table.data("values").count / $table.find(".circle").length

  $table.find("tbody tr").each ->
    $row      = $(this)
    $circles  = $row.find(".circle")

    values    = $.makeArray $circles.map -> $(this).data("values")

    $circles.each ->
      $circle = $(this)

      count   = $circle.data("values").count
      amount  = $circle.data("values").average_amount

      return if count == 0 || amount == 0

      title   = "Количество сделок: #{count}<br>Средний размер: $#{amount}M"

      $circle.attr("title", title)
      $circle.tooltip(html: true)

      radius  = Math.sqrt(amount / avgAmount) * avgRadius
      radius  = minRadius if radius < minRadius
      radius  = maxRadius if radius > maxRadius

      opacity = Math.sqrt(count / avgCount) * avgOpacity
      opacity = minOpacity if opacity < minOpacity
      opacity = maxOpacity if opacity > maxOpacity

      $circle.css
        "border-radius"   : "#{radius}px"
        "height"          : "#{radius*2}px"
        "width"           : "#{radius*2}px"
        "opacity"         : opacity

renderGeography = ->
  $map = $(".map")
  return if $map.length == 0

  maxRadius = 35.5
  minRadius = 8
  maxAmount = null
  minFontSize = 8

  for [name, count, amount, x, y] in $map.data("countries")
    maxAmount ||= amount

    $circle = $("<div class='circle' title='#{name}'>#{amount}</div>")
    $circle.tooltip()

    radius = Math.sqrt(amount / maxAmount) * maxRadius
    radius = minRadius if radius < minRadius

    fontSize = radius / 1.8
    fontSize = minFontSize if fontSize < minFontSize

    $circle.css
      "width"           : "#{radius*2}px"
      "height"          : "#{radius*2}px"
      "line-height"     : "#{radius*2}px"
      "background-size" : "#{radius*2}px"
      "font-size"       : "#{fontSize}px"
      "left"            : "#{x - radius}px"
      "top"             : "#{y - radius}px"

    $(".map").append($circle)

setFiltersPosition = ->
  $page = $(".overview")
  return if $page.length == 0

  $filters        = $page.find(".filters")
  offset          = $filters.offset().top
  origMarginTop   = parseInt $filters.css("margin-top")
  marginTop       = 5

  $(window).scroll ->
    console.log $filters.css("opacity")
    if $(window).scrollTop() >= offset - marginTop
      unless $filters.data("fixed")
        $filters.css
          "position"    : "fixed"
          "top"         : 0
          "left"        : $filters.offset().left
          "margin-top"  : marginTop
          "opacity"     : 0.8
          "z-index"     : 500
        $filters.data("fixed", true)
    else if $filters.data("fixed")
      $filters.css
        "position"      : "static"
        "opacity"       : 1
        "margin-top"    : origMarginTop
      $filters.data("fixed", false)

jQuery ->
  renderDirections()
  renderGeography()
  renderDirectionsRounds()
  setFiltersPosition()
