class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :user
      t.boolean :like
      t.references :voteable, :polymorphic => true

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :voteable_id
  end
end
