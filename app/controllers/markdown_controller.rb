class MarkdownController < ApplicationController
  def preview
    render text: markdown(params[:markdown])
  end
end
