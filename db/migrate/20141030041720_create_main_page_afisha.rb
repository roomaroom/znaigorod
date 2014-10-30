class CreateMainPageAfisha < ActiveRecord::Migration
  def create_main_page_afisha_records
    (1..6).each do |i|
      main_page_afisha = MainPagePoster.new(:position => i)
      main_page_afisha.save :validate => false
    end
  end

  def change
    create_table :main_page_posters do |t|
      t.integer :afisha_id
      t.integer :position
      t.datetime :expires_at
      t.timestamps
    end

    create_main_page_afisha_records
  end
end
