class LinkCounter < ActiveRecord::Base
  attr_accessible :name, :link_type, :link, :count

  extend Enumerize
  enumerize :link_type, :in => [:external, :banner, :right], scope: true
end
