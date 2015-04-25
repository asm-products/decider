class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.boolean :value
      t.references :proposal
      t.references :stakeholder

      t.timestamps
    end
  end
end
