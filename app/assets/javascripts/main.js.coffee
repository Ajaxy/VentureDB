class Form
  error: (formHTML) ->
    @popup.html(formHTML)
    rebindInputs(@popup)

  success: ->
    @popup.find(":input").val("")
    @popup.modal("hide")
    @popup.trigger("close")

class AuthorsForm extends Form
  constructor: (@popup, @entriesList) ->

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

window.searchField = ($el, baseUrl) ->
  $el.on "change", ->
    id = $(this).val()
    if id.length > 0
      $.ajax
        dataType: "script"
        url:  "#{baseUrl}/#{id}"
        success: => $(this).val("").trigger("liszt:updated")

window.rebindInputs = (selector = "body") ->
  $("select.chzn", selector).chosen(disable_search_threshold: 15)

  $("[data-dismiss=dialog]").click ->
    $(this).closest(".ui-dialog-content").dialog("close")

  $("[data-toggle=dialog]").click ->
    $($(this).attr("href")).dialog(resizeable: false, width: 1000, zIndex: 1000)
    $("body").append("<div class='dialog-backdrop'></div>")

  $("body").on "click", ".dialog-backdrop", ->
    $(".ui-dialog-content").trigger("close")

  $("body").on "close", ".ui-dialog-content", ->
    $(this).dialog("close")
    $(".dialog-backdrop").remove()

jQuery ->
  rebindInputs()

  $(".entries-list").on "click", ".remove-entry", ->
    $(this).closest(".entry").remove()

  if $("form.project").length > 0
    window.authorForm = new AuthorsForm $("#create_author"), $("form.project .authors")
    searchField $("#find_authors"), "/people"

    window.companyForm = new AddToSelectForm $("#create_company"), $("form.project #project_company_id")

    window.investorCompanyForm = new AddToSelectForm $("#create_company"), $("form.project #project_company_id")

    window.projectForm = new AddToSelectForm $("#create_project"), $("form.deal #deal_project_id")

  # if $("form.deal").length > 0
  #   window.investorForm = new PopupForm $("#create_investor"), $("form.deal .investors")
  #   searchField $("#find_investors"), "/investors"
