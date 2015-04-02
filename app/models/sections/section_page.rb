class SectionPage < ActiveRecord::Base
  include ActionView::Helpers::SanitizeHelper

  validates_presence_of :title, :content

  attr_accessible :title, :content, :poster, :vfs_path, :poster_image

  has_many :gallery_images,        :as => :attachable,     :dependent => :destroy
  belongs_to :section

  has_attached_file :poster_image, storage: :elvfs, elvfs_url: Settings['storage.url']

  def self.generate_vfs_path
    "/znaigorod/section_pages/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
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

