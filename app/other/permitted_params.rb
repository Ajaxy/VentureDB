# encoding: utf-8

class PermittedParams < Struct.new(:params, :user)
  def company
    params.require(:company).permit(*company_attributes)
  end

  def deal
    params.require(:deal).permit(*deal_attributes)
  end

  def investment
    params.require(:investment).permit(*investment_attributes)
  end

  def investor
    params.require(:investor).permit(*investor_attributes,
      company: company_attributes, person: person_attributes)
  end

  def feedback
    params.require(:feedback).permit(:type_id, :name, :phone, :text)
  end

  def person
    params.require(:person).permit(*person_attributes)
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

  def event
    params.require(:event).permit(*event_attributes)
  end

  def selection
    params.require(:selection).permit(*selection_attributes, formats: [])
  end

  private

  def actor_attributes
    params[:type] == "person" ? person_attributes : company_attributes
  end

  def company_attributes
    %w[name full_name form place description type_id from_connections_attributes www1 www2 vkontakte1
      vkontakte2 facebook1 facebook2 phone1 phone2 address1 address2 vacancies1 vacancies2 details
      secret_details opened mentions market_ids scope_ids foundation_date email1 email2 prev_name]
  end

  def deal_attributes
    %w[company_id project_id announcement_date contract_date approx_date status_id
      exit_type_id stage_id amount_rub amount_usd amount_eur
      approx_amount value_before value_after investment_ids
      format_id round_id
      mentions comments errors_log
      approx_amount_note
      value_before_usd value_before_eur value_before_approx value_before_approx_note
      value_after_usd value_after_eur value_after_approx value_after_approx_note
    ]
  end

  def investment_attributes
    %w[investor_id instrument_id share]
  end

  def investor_attributes
    %w[type_id location_ids]
  end

  def person_attributes
    %w[name type_id sex education age description country sectors address phone website
      facebook slideshare vkontakte vacancies mentions other_geo from_connections_attributes
      birth_date email www plan
      plan_ends_at used_connections used_profiles_acc used_downloads used_support_mins
      legal_title legal_address legal_ogrn legal_inn plan_order_plan plan_order_months plan_order_datetime]
  end

  def project_attributes
    %w[name description scope_ids market_ids author_ids]
  end

  def subscription_attributes
    %w[name company email legal_title legal_address legal_ogrn legal_inn]
  end

  def user_attributes
    %w[type email password]
  end

  def event_attributes
    %w[name description investor_organizer_ids project_organizer_ids
      investor_organizer_ids project_participant_ids
      company_organizer_ids company_participant_ids]
  end

  def selection_attributes
    %w[title filter mailing status_id formats amount_from amount_to year quarter amount_without_empty amount_without_approx]
  end
end
