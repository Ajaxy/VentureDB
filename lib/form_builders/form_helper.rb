# encoding: utf-8

module Venture
  module FormHelper
    def markdown_textarea(object_name, method, options = {})
      if options[:class].empty?
        options[:class] = "js-markdown"
      else
        options[:class] << " js-markdown"
      end

      textarea  = text_area(object_name, method, options)
      random_id = Random.rand(1000)

      render partial: "markdown_field", locals: { textarea: textarea, random_id: random_id }
    end
  end

  module FormBuilder
    def markdown_textarea(method, options = {})
      @template.markdown_textarea(@object_name, method, objectify_options(options))
    end
  end
end
