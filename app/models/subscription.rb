# encoding: utf-8

class Subscription < ActiveRecord::Base
  validates :email, format: /.@./
end
