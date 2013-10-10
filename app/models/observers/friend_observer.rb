# encoding: utf-8

class FriendObserver < ActiveRecord::Observer
  def after_create(friend)
    NotificationMessage.delay(:queue => 'critical').create(
      account: friend.friendable,
      producer: friend.account,
      kind: :user_add_friend,
      messageable: friend)
  end

  def after_save(friend)
    if friend.friendly
      Feed.create(
        :feedable => friend,
        :account => friend.account
      )
    else
      friend.feed.destroy if friend.feed
    end
  end

end
