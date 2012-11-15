class Service < ActiveRecord::Base
  attr_accessible :age, :title, :feature, :tag

  belongs_to :context, :polymorphic => true

  validates_presence_of :title
end

# == Schema Information
#
# Table name: services
#
#  id           :integer          not null, primary key
#  title        :text
#  feature      :text
#  age          :text
#  tag          :text
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

