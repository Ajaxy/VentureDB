#= require jquery
#= require jquery_ujs
#= require jquery.placeholder
#= require bootstrap-tooltip
#= require bootstrap-dropdown
#= require bootstrap-typeahead
#= require sugar

window.vent =
  sub: (event, fn) ->
    $(@).bind(event, fn)

  unsub: (event) ->
    $(@).unbind(event)

  pub: (event) ->
    $(@).trigger(event)

jQuery ->
  $("input, textarea").placeholder();

  $(".promo form p ").after('<div class="form-error"></div><div class="form-success"></div>')

  $(".promo form").on "ajax:before", (e) ->
    $div = $ ".form-error", e.currentTarget
    $div.fadeOut("fast")

  $(".promo form").on "ajax:success", (e, data, status, xhr) ->
    if xhr.getResponseHeader "Location"
      top.location.href = xhr.getResponseHeader "Location"
      return false

    $(".form-body", e.currentTarget).fadeOut "fast", ->
      $(".form-success", e.currentTarget).fadeIn("fast")

  $(".promo form.new_subscription").on "ajax:success", (e, data, status, xhr) ->
    $("input.btn, span.or", e.currentTarget).hide()

  $(".promo form").on "ajax:error", (e, data, status, xhr) ->
    data = $.parseJSON(data.responseText)
    unless data.error
      errors = []
      for field, error of data.errors
        errors.push field + " " + error
      data.error = errors.join ", "
    $div = $ ".form-error", e.currentTarget
    $div.html( data.error ).fadeIn("fast")

  $(".promo .js-switch-form").on "click", (e) ->
    $el = $(e.currentTarget)
    $(".active").removeClass("active")
    $($el.data("form")).addClass("active")
    return false

  $("input[data-autosuggest='true']").typeahead
    minLength: 2

    source: (query, process) ->
      typeahead = @
      $.ajax
        dataType: "json"
        url:  "/search/suggest"
        data:
          query     : query
          entities  : @$element.data "autosuggest-entities"
        success: (response) ->
          typeahead.items = response
          process $.map(response, (item) -> item.title)

    updater: (selectedText) ->
      return selectedText unless @$element.data("autosuggest-navigate") == true

      selectedItem = $.grep(@items, (item) -> item.title == selectedText)[0]
      return selectedText unless selectedItem && selectedItem.url
      window.location.href = selectedItem.url
      return ""

