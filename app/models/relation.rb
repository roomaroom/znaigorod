class Relation < ActiveRecord::Base
  attr_accessor :slave_url

  attr_accessible :slave, :slave_url

  belongs_to :master, :polymorphic => true

  belongs_to :slave, :polymorphic => true
end
