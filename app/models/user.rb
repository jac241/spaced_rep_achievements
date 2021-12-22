class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  validates :username, presence: true, uniqueness: true, length: { minimum: 1, maximum: 50 }
  validates :email, presence: true, uniqueness: true

  has_many :notifications, foreign_key: :recipient_id
  has_many :services

  has_many :syncs, dependent: :destroy
  has_many :achievements, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :medal_statistics, through: :entries

  has_many :memberships, dependent: :destroy, foreign_key: "member_id"
  has_many :groups, through: :memberships

  has_many :membership_requests, dependent: :destroy
  has_many :requested_groups, through: :membership_requests, source: :group

  has_one :chase_mode_config, dependent: :destroy

  after_create :create_chase_mode_config!

  def self.online_ids
    joins(:achievements)
      .where("achievements.client_earned_at > ?", 5.minutes.ago)
      .pluck(:id)
      .to_set
  end

  def latest_achievement
    achievements.in_order_earned.last unless achievements.empty?
  end
end

