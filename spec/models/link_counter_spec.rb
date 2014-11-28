require 'spec_helper'

describe LinkCounter do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: link_counters
#
#  id         :integer          not null, primary key
#  link_type  :string(255)
#  name       :string(255)
#  human_name :string(255)
#  count      :integer          default(0)
#  link       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

