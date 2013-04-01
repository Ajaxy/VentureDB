# encoding: utf-8

module Admin
  module CompaniesHelper
    def type_field(form, local_assigns)
      type_id = if local_assigns.has_key? :type_id
        local_assigns[:type_id]
      elsif params[:type_id].present?
        params[:type_id]
      else
        nil
      end

      if type_id.present?
        form.hidden_field :type_id, value: local_assigns[:type_id]
      else
        form.label(:type_id, "Тип компании") +
          form.select(:type_id, Company.types, { include_blank: true }, class: "chzn span8")
      end
    end
  end
end
