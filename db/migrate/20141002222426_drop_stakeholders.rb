class DropStakeholders < ActiveRecord::Migration
  def change
    drop_table :stakeholders do |t|
      t.string :email
      t.references :proposal, index: true

      t.timestamps
    end
  end
end
