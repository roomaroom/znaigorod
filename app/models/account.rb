# encoding: utf-8

class Account < ActiveRecord::Base

  attr_accessible :avatar, :birthday, :email,
                  :first_name, :gender, :last_name, :patronymic,
                  :rating, :nickname, :location,
                  :account_settings_attributes

  has_many :users,           order: 'id ASC', dependent: :destroy
  has_many :afisha,          through: :users
  has_many :discounts
  has_many :showings,        through: :users
  has_many :comments,        through: :users, order: 'comments.created_at DESC'
  has_many :roles,           through: :users
  has_many :votes,           through: :users, order: 'votes.id DESC'
  has_many :visits,          through: :users, order: 'visits.created_at DESC'
  has_many :page_visits,     through: :users
  has_many :my_page_visits,  as: :page_visitable, class_name: PageVisit

  has_many :gallery_images,  dependent: :destroy, :as => :attachable

  has_many :invitations,     dependent: :destroy
  has_many :invite_messages, order: 'messages.created_at DESC', :through => :invitations

  has_many :received_invitations, :class_name => 'Invitation', :foreign_key => :invited_id
  has_many :received_invite_messages, :source => :invite_messages, order: 'messages.created_at DESC', :through => :received_invitations

  has_many :friends,         dependent: :destroy
  has_many :friendable,      as: :friendable, class_name: 'Friend'

  has_many :events,          through: :users, order: 'afisha.created_at DESC'

  has_many :messages,                     order: 'messages.created_at DESC'
  has_many :notification_messages,        order: 'messages.created_at DESC'
  has_many :private_messages,             order: 'messages.created_at DESC'
  has_many :produced_messages,            as: :producer, class_name: 'PrivateMessage'

  has_many :payments, through: :users

  has_many :feeds,           :dependent => :destroy

  has_one :account_settings, :dependent => :destroy
  accepts_nested_attributes_for :account_settings

  after_create :get_social_avatar, :create_account_settings

  before_destroy :remove_private_messages, :remove_friendable, :remove_comments

  alias_attribute :to_s, :title

  validates_email_format_of :email, :allow_blank => true

  scope :dating, -> { account_settings.dating? }

  scope :ordered, -> { order('ID ASC') }

  has_attached_file :avatar, :storage => :elvfs, :elvfs_url => Settings['storage.url'], :default_url => :resolve_default_avatar_url
  alias_attribute :file_url, :avatar_url

  extend Enumerize
  enumerize :gender, in: [:undefined, :male, :female], default: :undefined, predicates: true

  searchable do
    boolean(:with_avatar) { with_avatar? }
    boolean(:dating) { account_settings.dating? }

    text :first_name
    text :last_name
    text :patronymic
    text :nickname
    text :location
    text :title,     :stored => true

    string :gender
    float :rating,   :trie => true
    time :created_at, :trie => true
    integer(:friendable) { my_page_visits.count + received_invitations.count }
    string :search_kind
    string(:kind, :multiple => true) { indexing_kinds }
    string(:acts_as, :multiple => true) { acts_as }
    string(:friend_ids, :multiple => true) { friendable }

    string(:inviter_categories, :multiple => true) { invitations.inviter.with_categories.select(&:actual?).flat_map(&:categories).uniq }
    string(:invited_categories, :multiple => true) { invitations.invited.with_categories.select(&:actual?).flat_map(&:categories).uniq }

    text :title, :as => :term_text
  end

  Role.role.values.each do |role|
    define_method "is_#{role}?" do
      self.class.where(:id => id).joins(:roles).where('roles.role = ?', role).any?
    end
  end

  def limit_is_reached?
    if Invitation.where("account_id = ? and created_at > ?", self.id, DateTime.now - 1.day).count < 10
      false
    else
      true
    end
  end

  def remove_comments
    self.comments.each do |c|
      unless c.child.present?
        c.destroy
      else
        c.user_id = nil
        c.save!
      end
    end
  end

  def remove_private_messages
    PrivateMessage.where(:producer_id => self.id).each do |m|
      m.destroy
    end
  end

  def remove_friendable
    Friend.where(:friendable_id => self.id).each do |f|
      f.destroy
    end
  end

  def create_account_settings
    self.account_settings = AccountSettings.new
    self.save!
  end

  def with_avatar?
    ![
      "#{Settings['storage.url']}/files/44240/200-200/default_female_avatar.png",
      "#{Settings['storage.url']}/files/44241/200-200/default_male_avatar.png",
      "#{Settings['storage.url']}/files/44242/200-200/default_undefined_avatar.png",
      "#{Settings['storage.url']}/files/28694/200-200/default_avatar.png"
    ].include?(avatar.url)
  end

  def resolve_default_avatar_url
    return "#{Settings['storage.url']}/files/44240/200-200/default_female_avatar.png"     if gender.female?
    return "#{Settings['storage.url']}/files/44241/200-200/default_male_avatar.png"       if gender.male?
    return "#{Settings['storage.url']}/files/44242/200-200/default_undefined_avatar.png"  if gender.undefined?

    "#{Settings['storage.url']}/files/28694/200-200/default_avatar.png"
  end

  def friends_feeds(search)
    friends = self.friends.includes(:friendable => { :feeds => :feedable })
    feeds = [nil]
    friends.each do |friend|
      if friend.friendly?
        if search[:feedable_type] == 'Discount'
          feeds = feeds.concat(friend.friendable.feeds.discount_or_member)
        else
          feeds = feeds.concat(friend.friendable.feeds.where(search))
        end
      end
    end
    feeds.compact!

    unless feeds.blank?
      feeds = feeds.sort_by(&:created_at).reverse
    end

    feeds
  end

  def friends_count
    self.friends.where(:friendly => true).count
  end

  def images_count
    self.gallery_images.count
  end

  def age
    now = Time.zone.now.to_date
    age = now.year - self.birthday.year - ((now.month > self.birthday.month || (now.month == self.birthday.month && now.day >= self.birthday.day)) ? 0 : 1)
    I18n.t('account.age', :count => age)
  end

  def create_page_visit(session, user_agent, user)
    my_page_visit = self.my_page_visits.new
    my_page_visit.user_agent = user_agent.to_s.encode('UTF-8', :undef => :replace, :invalid => :replace, :replace => '')
    my_page_visit.user = user
    my_page_visit.save
  end

  def sended_invite_message(messageable, account_id, invite)
    self.invite_messages.where(messageable_id: messageable.id,
                                 messageable_type: messageable.class.name,
                                 account_id: account_id,
                                 invite_kind: invite).any?
  end

  def indexing_kinds
    array = roles.map(&:role)
    array << 'afisha_editor' if afisha.published.any?
    array
  end

  def search_kind
    self.class.name.underscore
  end

  def acts_as
    invitations.without_invited.select(&:actual?).map(&:kind).uniq
  end

  def title
    "#{first_name} #{last_name}".gsub(/\s$/,'')
  end

  def get_vkontakte_friends(user)
    vk_client = VkontakteApi::Client.new

    begin
      uids = vk_client.friends.get(user_id: user.uid)

      uids.each do |uid|
        if User.vkontakte.where(uid: uid.to_s).any?
          self.friends.create(friendable: get_account(uid.to_s), friendly: true) unless self.friends_with?(get_account(uid.to_s))
        end
      end
    rescue VkontakteApi::Error => e
    end
  end

  def get_facebook_friends(user)
    fb_client = Koala::Facebook::API.new(user.token)
    begin
      friends = fb_client.get_connections(user.uid, "friends")
      friends.each do |friend|
        if User.facebook.where(uid: friend['id']).any?
          self.friends.create(friendable: get_account(friend['id']), friendly: true) unless self.friends_with?(get_account(friend['id']))
        end
      end
    rescue
    end
  end

  def get_social_avatar
    begin
      user = users.first
      vk_client = VkontakteApi::Client.new
      fb_client = Koala::Facebook::API.new
      image_url = case user.provider
                  when 'vkontakte'
                    vk_client.users.get(uid: user.uid,
                                        fields: :photo_200_orig).first.photo_200_orig
                  when 'facebook'
                    fb_client.get_picture(user.uid, type: 'large')
                  when 'google_oauth2', 'twitter'
                    user.social_avatar_url
                  end
      set_avatar_from_url(image_url) if image_url
    rescue
    end
  end

  def set_avatar_from_url(url)
    self.avatar = URI.parse(url)
    save!
  end

  def get_account(uid)
    User.find_by_uid(uid).account
  end

  def link_to_social
    link = ''
    auth = users.first.auth_raw_info
    return link if auth.blank? || auth.is_a?(String)
    ["Facebook", "Mailru", "Odnoklassniki", "Twitter", "Vkontakte"].each do |provider|
      link = auth.info.urls.send(provider) if auth.info.urls.respond_to?(provider)
    end
    link = "#{link}id#{auth.uid}" if link == 'http://vk.com/'

    link
  end

  def update_rating
    update_attribute(:rating,
                     0.5 * payments.approved.where(:type=>'CopyPayment').map(&:copies).flatten.count +
                     0.25 * afisha.count +
                     0.1 * comments.count +
                     0.1 * visits.count +
                     0.01 * votes.liked.count +
                     0.01 * page_visits.count +
                     0.01 * my_page_visits.count)
  end

  def friendly_for(account)
    self.friends.where(friendable_id: account.id)
  end

  def friends_with?(account)
    self.friends.where(friendable_id: account.id, friendly: true).any?
  end

  def friendable
    Friend.where(:friendable_id => self.id).pluck(:account_id)
  end

  def dialogs
    dialogs = (PrivateMessage.to(self).includes(&:producer) + PrivateMessage.from(self).includes(&:account)).sort_by{|t| - t.created_at.to_i}

    accounts = []
    dialogs.each do |dialog|
      if dialog.producer_id == self.id
        accounts.push dialog.account
      else
        accounts.push dialog.producer
      end
    end

    accounts.uniq
  end

  def invitation_for(account, kind, category, inviteable)
    relation = invitations.send(kind)
      .where(:invited_id => account.id)
      .joins(:invite_messages).where('messages.agreement IS NULL')

    relation = relation.where(:category => category) if category.present?
    relation = relation.where(:inviteable_id => inviteable.id, :inviteable_type => inviteable.class.name) if inviteable

    relation.first
  end

  def invitation_without_invited_for(inviteable, kind)
    invitations.send(kind).where(:invited_id => nil)
      .where(:inviteable_id => inviteable.id, :inviteable_type => inviteable.class.name).first
  end

  def reacts_to?(invitation)
    relation = invitations.send(invitation.opposite_kind).where(:invited_id => invitation.account.id)
    relation = relation.where(:inviteable_type => invitation.inviteable.class.name, :inviteable_id => invitation.inviteable.id) if invitation.inviteable
    relation = relation.where(:category => invitation.category).where(:inviteable_type => nil) if invitation.category.present?

    relation.any?
  end
end

# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  first_name          :string(255)
#  last_name           :string(255)
#  patronymic          :string(255)
#  email               :string(255)
#  rating              :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  nickname            :string(255)
#  location            :string(255)
#  gender              :string(255)
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  avatar_url          :text
#  birthday            :date
#  last_visit_at       :datetime
#

