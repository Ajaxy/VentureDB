renderDirections = ->
  maxRadius   = 60
  minRadius   = 25

  backgrounds = ["9ba2ce", "b7554a", "ebb94a", "a9c48f", "2151a1", "bd6bc0"]

  $circlesRow = $(".directions .circles")
  $circles    = $circlesRow.find(".circle")

  width = 100 / $circles.length
  $circlesRow.find("> div").css("width": "#{width}%")

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


renderGeography = ->
  maxRadius = 35.5
  minRadius = 11.5
  maxAmount = null

  $map = $(".map")

  for [name, count, amount, x, y] in $map.data("countries")
    maxAmount ||= amount
    $circle = $("<div title='#{name}'>#{amount}</div>")

    radius = Math.sqrt(amount / maxAmount) * maxRadius
    radius = minRadius if radius < minRadius

    $circle.css
      "width"           : "#{radius*2}px"
      "height"          : "#{radius*2}px"
      "line-height"     : "#{radius*2}px"
      "background-size" : "#{radius*2}px"
      "font-size"       : "#{radius/1.5}px"
      "left"            : "#{x - radius}px"
      "top"             : "#{y - radius}px"


    $(".map").append($circle)

jQuery ->
  renderDirections()
  renderGeography()