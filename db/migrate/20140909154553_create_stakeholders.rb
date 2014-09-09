class CreateStakeholders < ActiveRecord::Migration
  def change
    create_table :stakeholders do |t|
      t.string :email
      t.references :proposal, index: true

      t.timestamps
    end
  end
end
