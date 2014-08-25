class Relation < ActiveRecord::Base
  attr_accessor :slave_url

  attr_accessible :slave, :slave_url

  belongs_to :master, :polymorphic => true

  belongs_to :slave, :polymorphic => true
end

# == Schema Information
#
# Table name: relations
#
#  id          :integer          not null, primary key
#  master_id   :integer
#  master_type :string(255)
#  slave_id    :integer
#  slave_type  :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

