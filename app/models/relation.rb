class Relation < ActiveRecord::Base
  attr_accessor :slave_url

  attr_accessible :slave, :slave_url

  before_create :set_slave_from_url

  belongs_to :master, :polymorphic => true

  belongs_to :slave, :polymorphic => true

  private

  def set_slave_from_url
    self.slave = UrlToRecord.new(slave_url).record
  end
end
