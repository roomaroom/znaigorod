class CreateListPosters < ActiveRecord::Migration
  def create_list_afisha_records
    (1..4).each do |i|
      list_afisha = AfishaListPoster.new(:position => i)
      list_afisha.save :validate => false
    end
  end

  def change
    create_table :afisha_list_posters do |t|
      t.integer :position
      t.datetime :expires_at
      t.belongs_to :afisha
      t.timestamps
    end

    create_list_afisha_records
  end
end
