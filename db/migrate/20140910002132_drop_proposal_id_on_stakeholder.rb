class DropProposalIdOnStakeholder < ActiveRecord::Migration
  def up
    remove_column :stakeholders, :proposal_id
  end
end
