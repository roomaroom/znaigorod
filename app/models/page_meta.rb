class PageMeta < ActiveRecord::Base
  include AutoHtml
  attr_accessible :path, :description, :header, :introduction, :keywords, :og_description, :og_title, :title
  validates_uniqueness_of :path
  validates_presence_of :path, :description, :header, :introduction, :keywords, :og_description, :og_title, :title

  def html_introduction
    introduction.to_s.as_html
  end

  auto_html_for :introduction do
    redcloth :target => '_blank', :rel => 'nofollow'
  end
end
