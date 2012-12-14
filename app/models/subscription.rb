# encoding: utf-8

class Subscription < ActiveRecord::Base
  validates :email, format: /.@./
  validates :name, presence: true

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
end
