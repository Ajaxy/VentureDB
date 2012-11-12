class Form
  error: (formHTML) ->
    @popup.html(formHTML)
    rebindInputs(@popup)

  success: ->
    @popup.find(":input").val("").trigger("change")
    @popup.find("select.chzn").trigger("liszt:updated")
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
          url:  "/people/#{id}"
          success: => $(this).val("").trigger("liszt:updated")

  success: (id, entryHTML) ->
    super
    if @entriesList.find(".entry[data-id=#{id}]").length == 0
      @entriesList.append(entryHTML)

class InvestmentForm extends Form
  constructor: ->
    @popup = $("#create_investment")
    @entriesList = $("form.deal .investments")

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

class InvestorForm extends AddToSelectForm
  constructor: ->
    super $("#create_investor"), $("form.investment #investment_investor_id")

    @typeSelect = @popup.find("#investor_type_id")
    @typeSelect.change =>
      switch @typeSelect.val() * 1
        when 10, 12 then @showPersonForm()
        else             @showCompanyForm()
    @typeSelect.change()

  showPersonForm: ->
    @popup.find(".person-fields").show()
    @popup.find(".company-fields").hide()

  showCompanyForm: ->
    @popup.find(".person-fields").hide()
    @popup.find(".company-fields").show()

class ProjectForm extends AddToSelectForm
  constructor: ->
    super $("#create_project"), $("form.deal #deal_project_id")

class InformerForm extends AddToSelectForm
  constructor: ->
    super $("#create_informer"), $("form.deal #deal_informer_id")

window.rebindInputs = (selector = "body") ->
  $("select.chzn", selector).chosen(disable_search_threshold: 15)

  if $("form.project", selector).length > 0
    window.projectForm = new ProjectForm

  if $("form.project", selector).length > 0
    window.authorForm = new AuthorsForm

  if $("form.investment", selector).length > 0
    window.investmentForm = new InvestmentForm

  if $("form.investor", selector).length > 0
    window.investorForm = new InvestorForm

  if $("form.deal", selector).length > 0
    window.informerForm = new InformerForm

jQuery ->
  rebindInputs()

  $("body").on "click", "[data-dismiss=dialog]", ->
    $(this).closest(".ui-dialog-content").dialog("close")
    false

  $("body").on "click", "[data-toggle=dialog]", ->
    $($(this).attr("href")).dialog(resizeable: false, width: 1000, zIndex: 1000)
    $("body").append("<div class='dialog-backdrop'></div>")
    false

  $("body").on "click", ".dialog-backdrop", ->
    $(".ui-dialog-content").trigger("close")
    false

  $("body").on "close", ".ui-dialog-content", ->
    $(this).dialog("close")
    $(".dialog-backdrop").remove()

  $("body").on "click", ".entries-list .remove-entry", ->
    $(this).closest(".entry").remove()
    false
