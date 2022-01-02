class Challenge < ApplicationRecord
  belongs_to :battle_pass
  scope :active, -> { where(active: true) }
end
