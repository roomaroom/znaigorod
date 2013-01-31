class AddSlugToWorks < ActiveRecord::Migration
  def up
    add_column :works, :slug, :string
    add_index :works, :slug, unique: true

    bar = ProgressBar.new(Work.count)
    Work.all.each do |work|
      work.save
      bar.increment!
    end
  end

  def down
    remove_index :works, :slug
    remove_column :works, :slug
  end
end
