# encoding: utf-8

class Subscription < ActiveRecord::Base
  validates :email, format: /.@./
  validates :name, presence: true

  after_save :approve, if: :auto_confirm_subscription?

  def self.present
    where{archived_at == nil}
  end

  def user_registered?
    email.present? and user.present?
  end

  def user
    @user ||= User.find_by_email(self.email)
  end

  def archive
    update_attribute :archived_at, Time.current
  end

  def create_user
    User.new do |user|
      user.email = email
      user.password = User.generate_password

      user.build_person do |person|
        person.name    = name
        person.type_id = Person::TYPE_EXPERT_ID
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
end
