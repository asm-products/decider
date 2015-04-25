class RenameStakeholderToUserInReplies < ActiveRecord::Migration
  def change
    rename_column :replies, :stakeholder_id, :user_id
  end
end
