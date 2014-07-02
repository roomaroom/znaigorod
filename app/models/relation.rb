class Relation < ActiveRecord::Base
  attr_accessible :slave

  belongs_to :master, :polymorphic => true

  belongs_to :slave, :polymorphic => true
end
