class Sync < ApplicationRecord
  validates :client_uuid, presence: true
  belongs_to :user

  has_one_attached :achievements_file
  has_many :achievements, dependent: :destroy
end
