# encoding: utf-8

class PermittedParams < Struct.new(:params, :user)
  def project
    params.require(:project).permit(*project_attributes)
  end

  def person
    params.require(:person).permit(*person_attributes)
  end

  private

  def project_attributes
    %w[name description company_name]
  end

  def person_attributes
    %w[first_name last_name middle_name email phone]
  end
end

