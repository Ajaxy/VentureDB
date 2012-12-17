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

renderDirectionsStages = ->
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

      count         = $circle.data("values").count
      amount        = $circle.data("values").average_amount
      amountString  = $circle.data("values").amount_string

      return if count == 0 || amount == 0

      title   = "Количество сделок: #{count}<br>Средний размер: #{amountString}"

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

  pluralize = (num, form1, form2, form3) =>
    num = Math.round(num*1)
    forms = ["#{num} #{form1}", "#{num} #{form2}", "#{num} #{form3}"]

    return forms[2] if 10 < (num % 100) < 20
    return forms[0] if num % 10 == 1
    return forms[1] if num % 10 in [2..4]
    forms[2]

  for [name, count, amount, amountString, x, y] in $map.data("countries")
    maxAmount ||= amount

    amountRounded = Math.round(amount / 1000000)
    countString = pluralize count, "сделка", "сделки", "сделок"

    tooltip = "#{name}<br>#{countString}<br>#{amountString}"

    $circle = $("<div class='circle' title='#{tooltip}'>#{amountRounded}</div>")
    $circle.tooltip(html: true)

    radius = Math.sqrt(amount / maxAmount) * maxRadius
    radius = minRadius if radius < minRadius

    fontSize = radius / 1.8
    fontSize = minFontSize if fontSize < minFontSize

    $circle.css
      "width"           : "#{radius*2}px"
      "height"          : "#{radius*2}px"
      "line-height"     : "#{radius*2}px"
      "font-size"       : "#{fontSize}px"
      "left"            : "#{x - radius}px"
      "top"             : "#{y - radius}px"

    $(".map").append($circle)

setFiltersPosition = ->
  $page = $(".overview")
  return if $page.length == 0

  $filters        = $page.find(".filters")
  return if $filters.length == 0

  offset          = $filters.offset().top
  origMarginTop   = parseInt $filters.css("margin-top")
  marginTop       = 5

  $(window).scroll ->
    if $(window).scrollTop() >= offset - marginTop
      unless $filters.data("fixed")
        $filters.css
          "position"    : "fixed"
          "top"         : 0
          "left"        : $filters.offset().left
          "margin-top"  : marginTop
          "opacity"     : 0.9
          "z-index"     : 500
        $filters.data("fixed", true)
    else if $filters.data("fixed")
      $filters.css
        "position"      : "static"
        "opacity"       : 1
        "margin-top"    : origMarginTop
      $filters.data("fixed", false)

  $(window).scroll()

onload = ->
  renderDirections()
  renderGeography()
  renderDirectionsStages()
  setFiltersPosition()

window.drawChart = (chart, data, options) ->
  [header, data...] = data

  dataTable = new google.visualization.DataTable
  dataTable.addColumn(column) for column in header
  dataTable.addRows(data)

  chart.draw(dataTable, options)

jQuery ->
  onload()

  $overview = $("section.overview")

  $overview.on "click", "a.js-reload-stats", ->
    url = $(this).attr("href")
    return if url == "#"

    $.ajax
      url: url
      beforeSend: ->
        $overview.css(opacity: 0.35)
      success: (data) ->
        vent.unsub("googleChartsLoaded")
        $overview.html(data)
        onload()
        vent.pub("googleChartsLoaded")
        $overview.css(opacity: 1)

    false
