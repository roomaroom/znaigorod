class AddPositionToSectionPage < ActiveRecord::Migration
  def change
    add_column :section_pages, :position, :integer
  end
end
