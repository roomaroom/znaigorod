class AddOurCamToWebcams < ActiveRecord::Migration
  def change
    add_column :webcams, :our_cam, :boolean, :default => false
  end
end
