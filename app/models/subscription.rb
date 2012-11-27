class Subscription < ActiveRecord::Base
  validates :email, format: /.@./
end
