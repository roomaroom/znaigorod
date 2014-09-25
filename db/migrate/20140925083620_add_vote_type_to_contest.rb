class AddVoteTypeToContest < ActiveRecord::Migration
  def change
    add_column :contests, :vote_type, :string

    Contest.update_all :vote_type => "like"
  end
end
