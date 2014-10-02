class ReplaceProposerWithUser < ActiveRecord::Migration
  def change
    remove_column :proposals, :proposer, :string
    add_column :proposals, :user_id, :integer
  end
end
