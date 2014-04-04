class MakePricePolymorphic < ActiveRecord::Migration
  def change
    add_column :prices, :context_id, :integer
    add_column :prices, :context_type, :string

    Price.update_all(:context_type => 'Service')
    Price.all.each do |price|
      price.update_column(:context_id, price.service_id)
    end

    remove_column :prices, :service_id
  end
end
