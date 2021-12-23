class AddGroupIdsToChaseModeConfig < ActiveRecord::Migration[6.0]
  def change
    add_column :chase_mode_configs, :group_ids, :integer, array: true,
                                                          default: []
  end
end
