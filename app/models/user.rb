# encoding: utf-8

class User < ActiveRecord::Base
  self.inheritance_column = "_type"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :confirmable,
  # :lockable, :timeoutable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  belongs_to :person

  before_validation :fill_defaults
  after_create :send_email

  accepts_nested_attributes_for :person

  TYPES = {
    "reader" => "Читатель",
    "admin"  => "Администратор",
  }

  def self.generate_password
    SecureRandom.send(:urlsafe_base64).first(8)
  end

  def fill_defaults
    if self.new_record?
      self.password = User.generate_password
    end
  end

  def send_email
    SubscriptionMailer.approved(self).deliver
  end

  def type
    self[:type].presence || "reader"
  end

  def admin?
    type == "admin"
  end

  def remind_already_registered
    send(:generate_reset_password_token!)
    UserMailer.remind_already_registered(self).deliver
  end

  def person
    super || Person.new
  end

  private

  def before_create

  end
end
