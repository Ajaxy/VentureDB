class Connection < ActiveRecord::Base
  attr_accessible :from_id, :from_type, :to_type, :to_id, :connection_type_id

  belongs_to :connection_type
  belongs_to :from, polymorphic: true
  belongs_to :to, polymorphic: true

  # validates :from_id, presence: true
  validates :from_type, presence: true
  validates :to_id, presence: true
  validates :to_type, presence: true
end
