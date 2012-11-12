class Form
  error: (formHTML) ->
    @popup.html(formHTML)
    rebindInputs(@popup)

  success: ->
    @popup.find(":input").val("")
    @popup.find(".field_with_errors").each -> $(this).replaceWith $(this).html()
    @popup.find(".entries-list").html("")
    @popup.modal("hide")
    @popup.trigger("close")

class AuthorsForm extends Form
  constructor: ->
    @popup = $("#create_author")
    @entriesList = $("form.project .authors")

    $("#find_authors").on "change", ->
      id = $(this).val()
      if id.length > 0
        $.ajax
          dataType: "script"
          url:  "/authors/#{id}"
          success: => $(this).val("").trigger("liszt:updated")

  success: (id, entryHTML) ->
    super
    if @entriesList.find(".entry[data-id=#{id}]").length == 0
      @entriesList.append(entryHTML)

class AddToSelectForm extends Form
  constructor: (@popup, @select) ->

  success: (id, name) ->
    super
    @select.append "<option value='#{id}'>#{name}</option>"
    @select.val(id).trigger("liszt:updated")

window.rebindInputs = (selector = "body") ->
  $("select.chzn", selector).chosen(disable_search_threshold: 15)

  if $("form.project", selector).length > 0
    window.authorForm = new AuthorsForm

  if $("form.deal", selector).length > 0
    window.projectForm = new AddToSelectForm $("#create_project"), $("form.deal #deal_project_id")

jQuery ->
  rebindInputs()

  $("body").on "click", "[data-dismiss=dialog]", ->
    $(this).closest(".ui-dialog-content").dialog("close")

  $("body").on "click", "[data-toggle=dialog]", ->
    $($(this).attr("href")).dialog(resizeable: false, width: 1000, zIndex: 1000)
    $("body").append("<div class='dialog-backdrop'></div>")

  $("body").on "click", ".dialog-backdrop", ->
    $(".ui-dialog-content").trigger("close")

  $("body").on "close", ".ui-dialog-content", ->
    $(this).dialog("close")
    $(".dialog-backdrop").remove()

  $("body").on "click", ".entries-list .remove-entry", ->
    $(this).closest(".entry").remove()
