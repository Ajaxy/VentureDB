# encoding: utf-8

class CabinetMenu
  def initialize(view)
    @view = view
  end

  def item(name, controller)
    html_class = controller.to_s
    html_class << " active" if @view.controller_name == controller.to_s

    @view.content_tag :li do
      @view.link_to name, controller, class: html_class
    end
  end
end
