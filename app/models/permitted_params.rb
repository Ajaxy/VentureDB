# encoding: utf-8

class PermittedParams < Struct.new(:params, :user)
  def project
    params.require(:project).permit(*project_attributes,
      company_attributes: company_attributes)
  end

  def person
    params.require(:person).permit(*person_attributes)
  end

  private

  def company_attributes
    %w[name full_name form place]
  end

  def project_attributes
    %w[name description scope_ids market_ids author_ids]
  end

  def person_attributes
    %w[first_name last_name middle_name email phone]
  end
end

