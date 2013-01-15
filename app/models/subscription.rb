# encoding: utf-8

class Subscription < ActiveRecord::Base
  validates :email, format: /.@./, uniqueness: true
  validates :name, presence: true
  validate  :user_already_registered, on: :create

  after_save :approve, if: :auto_confirm_subscription?

  def self.present
    where{archived_at == nil}
  end

  def archive
    update_attribute :archived_at, Time.current
  end

  def create_user
    User.new do |user|
      user.email = email
      user.password = User.generate_password

      user.build_person do |person|
        name_parts = name.to_s.split

        if name_parts.size == 3
          person.last_name, person.first_name, person.middle_name = name_parts
        else
          person.first_name, person.last_name = name_parts
        end
      end
    end
  end

  def approve
    user = create_user
    SubscriptionMailer.approved(user).deliver if user.save
  end

  def auto_confirm_subscription?
    AUTO_CONFIRM_SUBSCRIPTION
  end

  private

  def user_already_registered
    if User.exists?(email: self.email)
      errors.add(:email, "уже использован")
    end
  end
end
