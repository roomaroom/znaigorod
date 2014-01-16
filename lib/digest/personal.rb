require 'invitation'
require 'notification_message'

class Digest::Personal

  attr_accessor :digest, :account, :period

  def initialize(account, period)
    @account = account
    @period = period
    @digest = [
      invitations,
      private_messages,
      comment_likes,
      comment_answers,
      material_comments,
    ].compact
  end

  def invitations
    invitations = []
    invite = Invitation.where(['invited_id = ? and created_at > ?', @account.id, Time.zone.now - @period])
    invite.each do  |i|
      if i.invite_messages.where(:state => 'unread').any?
        invitations.push i
      end
    end
    invitations
  end

  def private_messages
    @account.private_messages.where("state = 'unread' and created_at > ?", Time.zone.now - @period)
  end

  def comment_likes
    likes = []
    notifications = NotificationMessage.where("state = 'unread' and " +
                                              "messageable_type = 'Vote' and " +
                                              "account_id = ? and " +
                                              "created_at > ?",
                                              @account.id, Time.zone.now - @period)
    notifications.each do |n|
      if n.messageable.voteable_type == "Comment"
        likes.push n.messageable
      end
    end
    likes
  end

  def comment_answers
    comments = []
    notifications = NotificationMessage.where("state = 'unread' and " +
                                              "messageable_type = 'Comment' and " +
                                              "account_id = ? and " +
                                              "created_at > ? and " +
                                              "kind = 'reply_on_comment'",
                                              @account.id, Time.zone.now - @period)
    notifications.each do |n|
      if n.messageable.parent.present?
        comments.push n.messageable
      end
    end
    comments
  end

  def material_comments
    comments = []

    notifications = NotificationMessage.where("state = 'unread' and " +
                                              "messageable_type = 'Comment' and " +
                                              "account_id = ? and " +
                                              "created_at > ? and " +
                                              "kind = 'new_comment'",
                                              @account.id, Time.zone.now - @period)
    notifications.each do |n|
      if %w[Afisha Discount].include?(n.messageable.commentable_type)
        comments.push n.messageable
      end
    end
    comments
  end

end
