# encoding: utf-8

class Subscription < ActiveRecord::Base
  validates :email, format: /.@./
  validates :name, presence: true
end
