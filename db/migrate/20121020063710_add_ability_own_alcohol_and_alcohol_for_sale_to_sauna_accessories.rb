class AddAbilityOwnAlcoholAndAlcoholForSaleToSaunaAccessories < ActiveRecord::Migration
  def change
    add_column :sauna_accessories, :ability_own_alcohol, :integer
    add_column :sauna_accessories, :alcohol_for_sale, :boolean
  end
end
