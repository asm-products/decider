class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.text :description
      t.string :proposer

      t.timestamps
    end
  end
end
