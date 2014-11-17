class CreateLinkCounters < ActiveRecord::Migration
  def change
    create_table :link_counters do |t|
      t.string :link_type
      t.string :name

      t.timestamps
    end
  end
end
