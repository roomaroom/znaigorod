class AddDefaultSortToContests < ActiveRecord::Migration
  def change
    add_column :contests, :default_sort, :string, :default => 'by_id'

    Contest.update_all :default_sort => 'by_id'
  end
end
