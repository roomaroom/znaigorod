# encoding: utf-8

class Price < ActiveRecord::Base
  belongs_to :context, :polymorphic => true

  default_scope order('value ASC')

  def price_value
    if self.max_value?
      if self.value == self.max_value
        "#{self.value}"
      else
        "#{self.value}&ndash;#{self.max_value}".html_safe
      end
    else
      "от #{self.value}"
    end
  end
end

# == Schema Information
#
# Table name: prices
#
#  id          :integer          not null, primary key
#  kind        :string(255)
#  value       :integer
#  count       :integer
#  period      :string(255)
#  service_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string(255)
#  max_value   :integer
#

