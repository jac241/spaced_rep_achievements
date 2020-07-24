class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true, uniqueness: true

  has_many :notifications, foreign_key: :recipient_id
  has_many :services

  has_many :syncs, dependent: :destroy
  has_many :achievements, dependent: :destroy
end

