#= require jquery
#= require jquery_ujs

window.vent =
  sub: (event, fn) ->
    $(@).bind(event, fn)

  pub: (event) ->
    $(@).trigger(event)

jQuery ->
  $(".promo button").click -> !! $("input[type=email]").val().match(/.@./)
