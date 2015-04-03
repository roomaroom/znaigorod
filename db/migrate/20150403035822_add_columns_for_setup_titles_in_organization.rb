class AddColumnsForSetupTitlesInOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :photo_block_title,     :string, :default => 'Фото'
    add_column :organizations, :discounts_block_title, :string, :default => 'Скидки'
    add_column :organizations, :afisha_block_title,    :string, :default => 'Афиша'
    add_column :organizations, :reviews_block_title,   :string, :default => 'Обзоры'
    add_column :organizations, :comments_block_title,  :string, :default => 'Отзывы'
  end
end
