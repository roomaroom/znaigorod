class PageMeta < ActiveRecord::Base
  include AutoHtml
  attr_accessible :path, :description, :header, :introduction, :keywords, :og_description, :og_title, :title, :og_image
  validates_uniqueness_of :path
  validates_presence_of :path, :description, :header, :introduction, :keywords, :og_description, :og_title, :title

  normalize_attribute :path, :with => :strip

  def html_introduction
    introduction.to_s.as_html
  end

  auto_html_for :introduction do
    redcloth
    external_links_attributes
    external_links_redirect
  end

  has_attached_file :og_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :og_image, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png'
  }

  def self.generate_vfs_path
    "/znaigorod/page_metas/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
end

# == Schema Information
#
# Table name: page_meta
#
#  id                    :integer          not null, primary key
#  path                  :text
#  title                 :text
#  header                :text
#  keywords              :text
#  description           :text
#  introduction          :text
#  og_title              :text
#  og_description        :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  og_image_file_name    :string(255)
#  og_image_content_type :string(255)
#  og_image_file_size    :integer
#  og_image_updated_at   :datetime
#  og_image_url          :text
#

