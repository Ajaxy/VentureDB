# encoding: utf-8

class User < ActiveRecord::Base
  self.inheritance_column = "_type"

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :company
  belongs_to :person

  def admin?
    type == "admin"
  end
end
