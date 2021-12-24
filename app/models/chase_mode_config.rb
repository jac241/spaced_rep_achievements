class ChaseModeConfig < ApplicationRecord
  belongs_to :user

  def group_ids=(new_group_ids)
    super(new_group_ids.reject(&:blank?))
  end
end
