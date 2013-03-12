# encoding: utf-8

class PermittedParams < Struct.new(:params, :user)
  
  def infrastructure
    params.require(:infrastructure).permit(*(company_attributes + contact_attributes))
  end

  def science
    params.require(:science).permit(*(company_attributes + contact_attributes))
  end

  def event
    params.require(:event).permit(*(company_attributes + contact_attributes))
  end

  def company
    params.require(:company).permit(*(company_attributes + contact_attributes))
  end

  def deal
    params.require(:deal).permit(*deal_attributes)
  end

  def investment
    params.require(:investment).permit(*investment_attributes)
  end

  def investor
    params.require(:investor).permit(*(company_attributes + contact_attributes))
  end

  def participation
    params.require(:participation).permit(:type_id, :name, :phone, :text)
  end

  def person
    params.require(:person).permit(*(person_attributes + contact_attributes))
  end

  def angel
    params.require(:angel).permit(*(person_attributes + contact_attributes))
  end

  def expert
    params.require(:expert).permit(*(person_attributes + contact_attributes))
  end

  def project
    params.require(:project).permit(*project_attributes,
      company_attributes: company_attributes)
  end

  def subscription
    params.require(:subscription).permit(*subscription_attributes)
  end

  def user
    params.require(:user).permit(*user_attributes,
      person_attributes: person_attributes)
  end

  private

  def actor_attributes
    params[:type] == "person" ? person_attributes : company_attributes
  end

  def company_attributes
    %w[name full_name form description type_id location_ids
      creation_date old_name sector_ids]
  end

  def deal_attributes
    %w[project_id announcement_date contract_date approx_date status_id
      round_id exit_type_id stage_id amount_rub amount_usd amount_eur
      approx_amount value_before value_after investment_ids informer_id
      mentions comments errors_log]
  end

  def investment_attributes
    %w[investor_id instrument_id share]
  end

  def investor_attributes
    %w[type_id location_ids]
  end

  def person_attributes
    %w[first_name last_name middle_name email phone description full_name
      type_id sex age country_ids sector_ids]
  end

  def project_attributes
    %w[name description scope_ids market_ids author_ids]
  end

  def subscription_attributes
    %w[name company email]
  end

  def user_attributes
    %w[type email password]
  end

  def event_attributes
    %w[name description investor_organizer_ids project_organizer_ids
      investor_organizer_ids project_participant_ids
      company_organizer_ids company_participant_ids]
  end

  def contact_attributes
    %w[address telephone website facebook slideshare
      vkontakte vacancies media other]    
  end
end
