#= require jquery
#= require jquery_ujs
#= require jquery.placeholder
#= require jquery.slides.min

#= require bootstrap
#= require bootstrap-popover
#= require bootstrap-tooltip
#= require bootstrap-dropdown
#= require bootstrap-typeahead
#= require bootstrap-datepicker/core
#= require bootstrap-datepicker/locales/bootstrap-datepicker.ru.js

#= require jquery.ui.slider
#= require sugar
#= require chosen-jquery
#= require promo
#= require selections

window.vent =
  sub: (event, fn) ->
    $(@).bind(event, fn)

  unsub: (event) ->
    $(@).unbind(event)

  pub: (event) ->
    $(@).trigger(event)

jQuery ->
  $("input, textarea").placeholder();

  $("select.chzn").chosen(disable_search_threshold: 15)
  $('.chosen-container').each((i, el) ->
    $(el).width($(el).prev().width())
  )

  $("body.promo form .submit").before('<div class="form-error"></div><div class="form-success"></div>')

  $("body.promo form").on "ajax:before", (e) ->
    $div = $ ".form-error", e.currentTarget
    $div.fadeOut("fast")

  $("body.promo form").on "ajax:success", (e, data, status, xhr) ->
    if xhr.getResponseHeader "Location"
      top.location.href = xhr.getResponseHeader "Location"
      return false

    $(".form-body", e.currentTarget).fadeOut "fast", ->
      $(".form-success", e.currentTarget).fadeIn("fast")

  $("form.new_subscription").on "submit", (e) ->
    $(this).find("input[type='submit']").attr('disabled', 'disabled')

  $("form.new_subscription").on "ajax:success", (e, data, status, xhr) ->
    $("input.btn, span.or", e.currentTarget).hide()
    $submit = $(".submit", e.currentTarget)
    $submit.addClass "submitted"
    $submit.find('a').addClass "btn"

  $("body.promo form").on "ajax:error", (e, data, status, xhr) ->
    data = $.parseJSON(data.responseText)
    unless data.error
      errors = []
      for field, error of data.errors
        errors.push field + " " + error
      data.error = errors.join ", "
    $div = $ ".form-error", e.currentTarget
    $div.html( data.error ).fadeIn("fast")
    $(this).find("input[type='submit']").removeAttr('disabled')

  $(".js-switch-form").on "click", (e) ->
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

  $('.datepicker').datepicker
    language: 'ru',
    autoclose: true,
    format: "dd.mm.yyyy"

  $('.extended-search').submit ->
    $('input[value=""]').attr('name','')
    $('input[input="submit"]').attr('name','')
    $('select').each ->
      if $(this).val() == ''
        $(this).attr 'name',''

  $('#toggle_extended_search').click ->
    $('form.extended-search').slideToggle()
    return false

  $('.sectors label.checkbox:not(.nested) input:checkbox').click ->
    label = $(this).parent()
    if !label.hasClass('nested')
      label.nextUntil('label:not(.nested)')
      .children()
      .attr 'checked', ($(this).attr('checked') != undefined)
  amount_start = $('#extended_search_amount_start').val()
  amount_end = $('#extended_search_amount_end').val()
  $("#slider-range").slider
    range: true,
    min: 0,
    max: 10000000,
    values:[amount_start, amount_end],
    slide: (event, ui) ->
      $('#extended_search_amount_start').val ui.values[0]
      $('#extended_search_amount_end').val ui.values[1]
      $(".amounts > p").first().text "$" + ui.values[0]
      $(".amounts > p").last().text "$" + ui.values[1]
  $(".amounts > p").first().
    text "$" + $('#extended_search_amount_start').val()
  $(".amounts > p").last().
    text "$" + $('#extended_search_amount_end').val()
  $('form.extended-search select').chosen({ disable_search_threshold: 1000 })

  $feedbackForm = $(".feedback form")

  $feedbackForm.on "click", ".option", (e) ->
    $option = $(e.target)
    return if $option.hasClass("selected")
    $feedbackForm.find(".option.selected").removeClass("selected")
    $option.addClass("selected")
    $feedbackForm.find("#feedback_type_id").val $option.data("value")
