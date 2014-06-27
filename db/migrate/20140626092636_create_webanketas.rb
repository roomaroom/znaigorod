class CreateWebanketas < ActiveRecord::Migration
  def change
    create_table :webanketas do |t|
      t.text :text
      t.datetime :expires_at
      t.references :context, :polymorphic => true

      t.timestamps
    end
    add_index :webanketas, :context_id
  end
end
