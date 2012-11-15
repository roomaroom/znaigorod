class AddTitleAndDescriptionToSuborganizations < ActiveRecord::Migration
  def change
    add_column :cultures, :title, :string
    add_column :cultures, :description, :text
    add_column :entertainments, :title, :string
    add_column :entertainments, :description, :text
    add_column :meals, :title, :string
    add_column :meals, :description, :text
    add_column :saunas, :title, :string
    add_column :saunas, :description, :text
    add_column :sports, :title, :string
    add_column :sports, :description, :text
  end
end
