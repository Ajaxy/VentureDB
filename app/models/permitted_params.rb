# encoding: utf-8

class PermittedParams < Struct.new(:params, :user)
  def project
    params.require(:project).permit(*project_attributes,
      company_attributes: company_attributes)
  end

  def person
    params.require(:person).permit(*person_attributes)
  end

  def investment
    params.require(:investment).permit(*investment_attributes)
  end

  def investor
    params.require(:investor).permit(*investor_attributes,
      company: company_attributes, person: person_attributes)
  end

  private

  def actor_attributes
    params[:type] == "person" ? person_attributes : company_attributes
  end

  def company_attributes
    %w[name full_name form place]
  end

  def investment_attributes
    %w[investor_id instrument_id share]
  end

  def investor_attributes
    %w[type_id]
  end

  def person_attributes
    %w[first_name last_name middle_name email phone]
  end

  def project_attributes
    %w[name description scope_ids market_ids author_ids]
  end
end
