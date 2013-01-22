(($) ->
  class Markdown

    constructor: (@textarea, @settings) ->
      @container        = @textarea.parents ".markdown-container"
      @previewPill      = @container.find ".tab-content .tab-pane.preview"
      @.textareaChanged = true
      $previewLink      = @container.find ".nav-tabs a.toggle-preview"

      context = @
      @textarea.on "keyup", ->
        context.textareaChanged = true
      $previewLink.on "show", (event) ->
        context.onPreview event

    onPreview: (event) ->
      return unless @.isTextAreaChanged()

      @.textareaChanged = false
      previewPill       = @previewPill
      textarea          = @textarea

      previewPill.text 'Загрузка...'

      $.post @settings.url,
        markdown: textarea.val()
        (data) ->
          previewPill.html data

    isTextAreaChanged: () ->
      @.textareaChanged

  $.markdown =
    globalSettings:
      url: '/'

  $.fn.markdown = (settings = {}) ->
    settings = $.extend {}, $.markdown.globalSettings, settings
    @each -> new Markdown $(@), settings
)(@jQuery)
