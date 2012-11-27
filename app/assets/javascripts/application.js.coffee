#= require jquery
#= require jquery_ujs

jQuery ->
  $(".promo button").click -> !! $("input[type=email]").val().match(/.@./)
