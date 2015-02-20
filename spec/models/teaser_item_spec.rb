require 'spec_helper'

describe TeaserItem do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: teaser_items
#
#  id                 :integer          not null, primary key
#  teaser_id          :integer
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :string(255)
#  image_url          :string(255)
#  url                :string(255)
#  link_text          :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  description        :text
#

