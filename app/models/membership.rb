class Membership < ApplicationRecord
  belongs_to :group, touch: true
  belongs_to :member, class_name: "User"
end
