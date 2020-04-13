class Sync < ApplicationRecord
  validates :client_uuid, presence: true

  has_one_attached :achievements_file
end
