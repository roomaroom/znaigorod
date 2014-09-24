# encoding: utf-8

class ContestPhoto < Contest
end

# == Schema Information
#
# Table name: contests
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  description           :text
#  starts_at             :datetime
#  ends_at               :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  vfs_path              :string(255)
#  slug                  :string(255)
#  og_description        :text
#  og_image_file_name    :string(255)
#  og_image_content_type :string(255)
#  og_image_file_size    :integer
#  og_image_updated_at   :datetime
#  og_image_url          :text
#  agreement             :text
#  participation_ends_at :datetime
#  type                  :string(255)
#

