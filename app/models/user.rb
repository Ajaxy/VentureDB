# encoding: utf-8

class User < ActiveRecord::Base
  self.inheritance_column = "_type"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable,# :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  belongs_to :person

  accepts_nested_attributes_for :person

  TYPES = {
    "reader" => "Читатель",
    "admin"  => "Администратор",
  }

  def self.generate_password
    SecureRandom.send(:urlsafe_base64).first(8)
  end

  def type
    self[:type].presence || "reader"
  end

  def admin?
    type == "admin"
  end
end
