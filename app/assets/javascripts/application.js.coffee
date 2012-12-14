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
  $(".promo .submit input").click ->
    return false unless $("#subscription_email").val().match(/.@./)
    return false unless $("#subscription_name").val().length > 0
    true
