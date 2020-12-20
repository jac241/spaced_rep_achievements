class Family < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true
  has_many :medals, dependent: :destroy
  has_many :reified_leaderboards, dependent: :destroy
end
