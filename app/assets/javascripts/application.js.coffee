#= require jquery
#= require jquery_ujs
#= require bootstrap-tooltip
#= require bootstrap-dropdown
#= require sugar

window.vent =
  sub: (event, fn) ->
    $(@).bind(event, fn)

  unsub: (event) ->
    $(@).unbind(event)

  pub: (event) ->
    $(@).trigger(event)

jQuery ->
  $(".promo button").click -> !! $("input[type=email]").val().match(/.@./)
