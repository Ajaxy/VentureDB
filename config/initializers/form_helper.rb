require File.join(Rails.root, "lib", "form_builders", "form_helper")

ActionView::Helpers::FormHelper.send(:include, Venture::FormHelper)
ActionView::Base.send(:include, Venture::FormHelper)
ActionView::Helpers::FormBuilder.send(:include, Venture::FormBuilder)
