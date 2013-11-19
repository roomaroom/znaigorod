class AddCodeToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :code, :string
  end
end
