class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  include DeviseTokenAuth::Concerns::User
  devise :masqueradable, :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable, :omniauthable, :confirmable

  validates :username, presence: true, uniqueness: true

  has_many :notifications, foreign_key: :recipient_id
  has_many :services

  has_many :syncs, dependent: :destroy
  has_many :achievements, dependent: :destroy
end

