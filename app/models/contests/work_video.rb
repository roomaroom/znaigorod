# encoding: utf-8

class WorkVideo < Work
  attr_accessible :video_url, :code
end

# == Schema Information
#
# Table name: works
#
#  id                 :integer          not null, primary key
#  image_url          :text
#  author_info        :string(255)
#  context_id         :integer
#  title              :string(255)
#  description        :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  slug               :string(255)
#  vk_likes           :integer
#  account_id         :integer
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  context_type       :string(255)
#  rating             :float
#  video_url          :string(255)
#  code               :integer
#  type               :string(255)
#

