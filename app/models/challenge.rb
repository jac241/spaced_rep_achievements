class Challenge < ApplicationRecord
  belongs_to :battle_pass, touch: true
  scope :active, -> { where(active: true) }
end
