# encoding: utf-8

class User < ActiveRecord::Base
  ADMIN_EMAILS = %w[admin@example.com]

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  belongs_to :person

  def admin?
    email.in?(ADMIN_EMAILS)
  end
end
