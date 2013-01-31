class AddSlugToContests < ActiveRecord::Migration
  def up
    add_column :contests, :slug, :string
    add_index :contests, :slug, unique: true

    bar = ProgressBar.new(Contest.count)
    Contest.all.each do |contest|
      contest.save
      bar.increment!
    end
  end

  def down
    remove_index :contests, :slug
    remove_column :contests, :slug
  end
end
