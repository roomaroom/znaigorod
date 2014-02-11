class AddParticipationEndsAtToContests < ActiveRecord::Migration
  def up
    add_column :contests, :participation_ends_at, :datetime
    Contest.all.each do |c|
      c.update_attribute(:participation_ends_at, c.ends_at)
    end
  end

  def down
    remove_column :contests, :participation_ends_at
  end
end
