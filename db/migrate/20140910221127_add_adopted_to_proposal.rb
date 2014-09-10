class AddAdoptedToProposal < ActiveRecord::Migration
  def change
    add_column :proposals, :adopted, :boolean
  end
end
