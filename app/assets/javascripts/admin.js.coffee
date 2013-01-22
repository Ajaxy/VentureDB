#= require jquery
#= require jquery_ujs
#= require jquery.ui.all
#= require bootstrap
#= require chosen-jquery
#= require jquery.autosize
#= require lib/markdown

class Form
  error: (formHTML, $el = @popup) ->
    $el.html(formHTML)
    rebindInputs($el)

  success: ($el = @popup) ->
    $el.find(":input").not("[type=hidden]").val("").trigger("change")
    $el.find("select.chzn").trigger("liszt:updated")
    $el.find(".field_with_errors").each -> $(this).replaceWith $(this).html()
    $el.find(".entries-list").html("")
    $el.modal("hide")
    $el.trigger("dialog:close")

class AuthorsForm extends Form
  constructor: ->
    @popup = $("#new_author")
    @entriesList = $("form.project .authors")

    $("#find_authors").on "change", ->
      id = $(this).val()
      if id.length > 0
        $.ajax
          dataType: "script"
          url:  "/admin/people/#{id}"
          success: -> $(this).val("").trigger("liszt:updated")

  success: (id, entryHTML) ->
    super()
    if @entriesList.find(".entry[data-id=#{id}]").length == 0
      @entriesList.append(entryHTML)

class InvestmentForm extends Form
  constructor: ->
    @popup = $("#new_investment")
    @entriesList = $("form.deal .investments")

  findEntry: (id) ->
    @entriesList.find(".entry[data-id=#{id}]")

  error: (dom_id, formHTML) ->
    $form = $("##{dom_id}")
    super(formHTML, $form)

  success: (id, entryHTML) ->
    $entry = @findEntry(id)
    if $entry.length == 0
      @entriesList.append(entryHTML)
      super()
    else
      $entry.replaceWith(entryHTML)
      super $("#investment_#{id}")

  showEdit: (formHTML) ->
    $form = $(formHTML)
    $("##{$form.attr("id")}").remove()
    $("body").append($form)
    rebindInputs($form)
    dialog($form)

class AddToSelectForm extends Form
  constructor: (@popup, @targetForm, @inputName) ->

  success: (id, name) ->
    super()
    @targetForm = $(@popup.data("target")) if @popup.data("target")
    $select = @targetForm.find("select[name='#{@inputName}']")
    $select.append "<option value='#{id}'>#{name}</option>"
    $select.val(id).trigger("liszt:updated")

class InvestorForm extends AddToSelectForm
  constructor: ->
    super $("#new_investor"), null, "investment[investor_id]"

    @typeSelect = @popup.find("#investor_type_id")
    @typeSelect.change =>
      switch @typeSelect.val() * 1
        when 11, 13 then @showPersonForm()
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
    super $("#new_project"), $("form.deal"), "deal[project_id]"

class InformerForm extends AddToSelectForm
  constructor: ->
    super $("#new_informer"), $("form.deal"), "deal[informer_id]"

class DealForm
  constructor: ->
    @form = $("form.deal")

    @roundSelect    = @form.find("#deal_round_id")
    @exitTypeField  = @form.find(".control-group.exit-type")

    @roundSelect.on "change", =>
      if @roundSelect.val() == "7"
        @exitTypeField.show()
      else
        @exitTypeField.hide()

    @roundSelect.change()

window.rebindInputs = (scope = document) ->
  $("select.chzn", scope).chosen(disable_search_threshold: 15)

  if $("form.project", scope).length > 0
    window.projectForm = new ProjectForm
    window.authorForm  = new AuthorsForm

  if $("form.investment", scope).length > 0
    window.investmentForm = new InvestmentForm

  if $("form.investor", scope).length > 0
    window.investorForm = new InvestorForm

  if $("form.deal", scope).length > 0
    window.informerForm = new InformerForm
    window.dealForm = new DealForm

  $("[rel=tooltip]", scope).tooltip(html: true)

window.dialog = ($el) ->
  $el.dialog(resizable: false, width: 1000, zIndex: 1000)
  $el.trigger("dialog:open")

jQuery ->
  rebindInputs()

  $(document).on "click", "[data-dismiss=dialog]", ->
    $(this).closest(".ui-dialog-content").trigger("dialog:close")
    false

  $(document).on "click", "[data-toggle=dialog]", ->
    dialog $($(this).attr("href"))
    false

  $(document).on "click", ".dialog-backdrop", ->
    $(".ui-dialog-content").trigger("dialog:close")
    false

  $(document).on "dialog:open", ".ui-dialog-content", ->
    $("body").append("<div class='dialog-backdrop'></div>")

  $(document).on "dialog:close", ".ui-dialog-content", ->
    $(this).dialog("close")
    $(".dialog-backdrop").remove()

  $(document).on "click", ".entries-list .controls .icon-remove", ->
    $(this).closest(".entry").remove()
    false

  $(document).on "click", "button.new_investor", ->
    $form = $("#new_investor")
    $form.data("target", "#" + $(this).closest(".container-popup").attr("id"))
    $form.modal("show")
    false

  $("textarea.js-markdown").markdown
    url: "/markdown/preview"
