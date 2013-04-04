class UserRating < ActiveRecord::Base
  attr_accessible :value

  belongs_to :user
  belongs_to :organization

  validates :value, :numericality => { :only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 4  }
  validates :user, :organization, :presence => true
  validates :user_id, :uniqueness => { :scope => :organization_id }

  after_save :organization_save!

  private

  def organization_save!
    organization.save!
  end
end
