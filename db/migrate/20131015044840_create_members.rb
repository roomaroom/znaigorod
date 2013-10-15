class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :memberable, :polymorphic => true
      t.references :account

      t.timestamps
    end
    add_index :members, :memberable_id
    add_index :members, :account_id
  end
end
