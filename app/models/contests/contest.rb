# encoding: utf-8

class Contest < ActiveRecord::Base
  extend FriendlyId

  attr_accessible :title, :description, :ends_at, :starts_at, :vfs_path, :og_description, :og_image

  has_many :works, :dependent => :destroy

  validates_presence_of :title

  scope :available, -> { where('starts_at <= ?', Time.zone.now).order('starts_at desc') }

  default_scope order('id DESC')

  friendly_id :title, use: :slugged

  has_attached_file :og_image, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  validates_attachment :og_image, :content_type => {
    :content_type => ['image/jpeg', 'image/jpg', 'image/png'],
    :message => 'Изображение должно быть в формате jpeg, jpg или png'
  }

  def self.generate_vfs_path
    "/znaigorod/contests/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end
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
#

