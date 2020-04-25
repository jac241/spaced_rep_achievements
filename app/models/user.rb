class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable
  has_secure_token

  validates :username, presence: true, uniqueness: true
  validates :token, uniqueness: true

  has_many :notifications, foreign_key: :recipient_id
  has_many :services

  has_many :syncs
  has_many :achievements

  def generate_unique_secure_token
    SecureRandom.base58(64)
  end
end
