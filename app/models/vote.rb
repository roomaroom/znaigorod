# encoding: utf-8

class Vote < ActiveRecord::Base
  attr_accessible :like, :user_id, :source

  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  has_many :messages, :as => :messageable, :dependent => :destroy
  has_one :feed, :as => :feedable, :dependent => :destroy

  validate :authenticated_user

  extend Enumerize
  enumerize :source, in: [:zg, :vk, :fb, :odn], :predicates => true, :default => :zg

  scope :afisha,        -> { where(:voteable_type => 'Afisha') }
  scope :liked,         -> { where(:like => true) }
  scope :without_user,  -> { where(:user_id => nil) }
  scope :with_user,     -> { where('user_id IS NOT NULL') }
  scope :source,        ->(type) { where(:source => type) }
  scope :rendereable,      -> { where(:voteable_type => ['Afisha', 'Organization']).where(:like => true) }

  def change_vote
    contest_not_end = if self.voteable.is_a?(Work)
             self.voteable.context.is_a?(Contest) ? self.voteable.context.ends_at > Time.zone.now : true
           else
             true
           end

    self.like = (like? ? false : true)
    self.save if contest_not_end
  end

  private
    def authenticated_user
      errors.add :like, 'может быть оставлена только зарегистрированным пользователем' if user.nil?
    end

end

# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  like          :boolean          default(FALSE)
#  voteable_id   :integer
#  voteable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  source        :string(255)
#

