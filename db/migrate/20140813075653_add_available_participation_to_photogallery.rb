class AddAvailableParticipationToPhotogallery < ActiveRecord::Migration
  def change
    add_column :photogalleries, :available_participation, :boolean
  end
end
