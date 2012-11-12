# encoding: utf-8

class InvestorForm
  include Virtus

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::ForbiddenAttributesProtection

  attr_reader :investor
  attr_reader :company
  attr_reader :person

  attribute :type_id, Integer
  validates :type_id, presence: true

  delegate :id, :name_and_type, to: :investor

  def actor
    type_id.in?(10, 12) ? person : company
  end

  def person=(attrs)
    @person = Person.new_draft(attrs)
  end

  def company=(attrs)
    @company = Company.new_draft(attrs)
  end

  def persisted?
    false
  end

  def save
    if valid? && actor.valid?
      persist!
      true
    else
      false
    end
  end

  private

  def persist!
    @investor = Investor.create_draft(type_id: type_id, actor: actor)
  end
end
