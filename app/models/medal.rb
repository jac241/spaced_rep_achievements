class Medal < ApplicationRecord
  validates :name, presence: true
  validates :client_medal_id, presence: true
  validates :rank, presence: true, numericality: true
  validates :score, presence: true, numericality: true

  has_many :achievements
  has_one_attached :image
  belongs_to :family, touch: true
  has_many :medal_statistics
end
