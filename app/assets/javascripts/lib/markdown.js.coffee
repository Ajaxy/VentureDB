(($) ->
  class Markdown

    constructor: (@textarea, @settings) ->
      @container = $('<div/>').addClass('markdown-container');
      @textarea.before @container
      textarea = @textarea.clone()
      @textarea.remove()
      @textarea = textarea

      @.buildTabs()
      @.buildHelp()

      @textarea.autosize()

      $('.nav-tabs a', @container).click (e) ->
        e.preventDefault()
        $(@).tab('show')

      @.textareaChanged = true
      context = @
      @textarea.on 'keyup', ->
        context.textareaChanged = true

    buildTabs: () ->
      $nav = $('<ul/>')
        .addClass('nav nav-tabs')
        .css('border-bottom': 0)
      $editLink = $('<a/>')
        .text('Редактировать')
        .attr(href: '#edit')
      $editLi = $('<li/>')
        .addClass('active')
        .append $editLink
      $nav.append $editLi

      $previewLink = $('<a/>')
        .text('Предпросмотр')
        .attr(href: '#preview')
      $previewLi = $('<li/>').append $previewLink
      $nav.append $previewLi

      @container.append $nav

      $tabContent = $('<div/>').addClass 'tab-content'
      $editPill   = $('<div/>')
        .addClass('tab-pane active')
        .attr(id: 'edit')
      $editPill.append @textarea
      $tabContent.append $editPill

      @previewPill = $('<div/>')
        .addClass('tab-pane')
        .attr(id: 'preview')
      $tabContent.append @previewPill

      @container.append $tabContent

      context = @
      $previewLink.on 'show', (event) ->
        context.onPreview event

    buildHelp: () ->
      helpHtml = '
        <div id="markdown_help" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <div class="modal-body">
            <h3>Форматирование текста</h3>
            <p>Заголовки</p>
            <pre>
# Это тег &lt;h1&gt;\n
## Это тег &lt;h2&gt;\n
### Это тег &lt;h3&gt;
            </pre>

            <p>Стили текста</p>
            <pre>
*Этот текст будет курсивным*\n
_Этот текст тоже будет курсивным_\n
**Этот текст будет жирным**\n
__Этот текст тоже будет жирным__
            </pre>

            <h3>Списки</h3>
            <p>Неупорядоченные</p>
            <pre>
* Элемент 1\n
* Элемент 2\n
  * Элемент 2a\n
  * Элемент 2b
            </pre>

            <p>Упорядоченные</p>
            <pre>
1. Элемент 1\n
2. Элемент 2\n
3. Элемент 3\n
  * Элемент 3a\n
  * Элемент 3b
            </pre>
            <h3>Прочее</h3>
            <p>Изображения</p>
            <pre>
![Логотип](/images/logo.png)\n
Формат: ![Alt text](url)
            </pre>
            <p>Ссылки</p>
            <pre>
http://google.com - автоматически!\n
[Google](http://google.com)
            </pre>
          </div>
          <div class="modal-footer">
            <button class="btn" data-dismiss="modal" aria-hidden="true">Закрыть</button>
          </div>
        </div>
      '
      @container.append(helpHtml)
      $helpLink = $('<a/>')
        .text('Справка по markdown')
        .attr(href: '#markdown_help')
        .css('display': 'inline-block', 'margin-bottom': '20px')
      $helpLink.on 'click', () ->
        $('#markdown_help').modal()
      @container.append($helpLink)

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
