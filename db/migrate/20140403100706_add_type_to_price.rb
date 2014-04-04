class AddTypeToPrice < ActiveRecord::Migration
  def change
    add_column :prices, :type, :string
    Price.update_all(:type => 'ServicePrice')
  end
end
