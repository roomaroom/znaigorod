class Contest < ActiveRecord::Base
  attr_accessible :title, :description, :ends_on, :starts_on, :published, :vfs_path

  has_many :works, :dependent => :destroy

  validates_presence_of :title

  scope :published, where(:published => true)

  def self.latest_contest
    order('created_at desc').first
  end

  def self.generate_vfs_path
    "/znaigorod/contests/#{Time.now.strftime('%Y/%m/%d/%H-%M')}-#{SecureRandom.hex(4)}"
  end

end

# == Schema Information
#
# Table name: contests
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  starts_on   :date
#  ends_on     :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  published   :boolean
#  vfs_path    :string(255)
#

