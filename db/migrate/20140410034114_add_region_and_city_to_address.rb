class AddRegionAndCityToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :region, :string
    add_column :addresses, :city, :string
    Address.update_all(:region => 'Томская область', :city => 'Томск')
  end
end
