class PageMeta < ActiveRecord::Base
  include AutoHtml
  attr_accessible :path, :description, :header, :introduction, :keywords, :og_description, :og_title, :title, :og_image
  validates_uniqueness_of :path
  validates_presence_of :path, :description, :header, :introduction, :keywords, :og_description, :og_title, :title

  def html_introduction
    introduction.to_s.as_html
  end

  auto_html_for :introduction do
    redcloth :target => '_blank', :rel => 'nofollow'
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
