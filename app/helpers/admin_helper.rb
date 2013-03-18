module AdminHelper
  def tabs(*tabs)
    content_tag :ul, class: 'nav nav-tabs' do
      tabs.each_with_index.map do |tab, index|
        content_tag :li, class: index.zero? ? 'active' : '' do
          link_to tab.first, tab.second, data: { toggle: "tab" }
        end
      end.join.html_safe
    end
  end

  def delete_button(entity)
    link_to content_tag(:i, "", class: "icon-trash icon-white"), [:admin, entity],
      method: :delete, class: "btn btn-small btn-danger"
  end
end
