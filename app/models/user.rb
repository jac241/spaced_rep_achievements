class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :omniauthable
  has_secure_token

  validates :username, presence: true, uniqueness: true

  has_many :notifications, foreign_key: :recipient_id
  has_many :services
end
