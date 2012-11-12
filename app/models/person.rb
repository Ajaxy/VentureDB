# encoding: utf-8

class Person < ActiveRecord::Base
  has_one :user

  has_many :investors, as: :actor
  has_many :investments, through: :investors

  validates :first_name, :last_name, presence: true

  def self.find_or_create(params)
    if person = where(params.slice(:first_name, :last_name, :email)).first
      person
    else
      create(params)
    end
  end

  def full_name
    if middle_name?
      "#{last_name} #{first_name} #{middle_name}"
    else
      "#{first_name} #{last_name}"
    end
  end
  alias_method :name, :full_name

  def full_name_with_email
    "#{full_name} #{email}"
  end
end
