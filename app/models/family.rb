class Family < ApplicationRecord
  validates :name, presence: true
  has_many :medals
end
