require 'spec_helper'

describe SectionPage do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: section_pages
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  content                   :text
#  section_id                :integer
#  poster_image_url          :string(255)
#  poster_image_file_name    :string(255)
#  poster_image_content_type :string(255)
#  poster_image_file_size    :string(255)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  vfs_path                  :string(255)
#  position                  :integer
#

