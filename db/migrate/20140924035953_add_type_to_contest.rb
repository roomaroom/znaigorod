class AddTypeToContest < ActiveRecord::Migration
  def change
    add_column :contests, :type, :string

    Contest.update_all :type => 'Contest'
  end
end
