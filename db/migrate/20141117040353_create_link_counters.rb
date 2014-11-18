class CreateLinkCounters < ActiveRecord::Migration
  def change
    create_table :link_counters do |t|
      t.string :link_type
      t.string :name
      t.string :human_name
      t.integer :count, default: 0
      t.string :link

      t.timestamps
    end
  end
end
