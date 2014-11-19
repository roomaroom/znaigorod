class LinkCounter < ActiveRecord::Base
  attr_accessible :name, :link_type, :link, :count

  extend Enumerize
  enumerize :link_type, :in => [:external, :banner, :right], scope: true

  def smart_name
    if human_name.present?
      human_name
    elsif name.present?
      name
    else
      "-"
    end
  end
end
