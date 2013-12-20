# encoding: utf-8

class SendPersonalDigest

  def self.made_digest(account, period)
    {
      notifications: notifications(account, period),
      invitations: invitations(account, period),
      private_messages: private_messages(account, period),
      comment_likes: comment_likes(account, period),
      comment_answers: comment_answers(account, period),
      afisha_comments: afisha_comments(account, period),
      discount_comments: discount_comments(account, period)
    }
  end

  def self.notifications(period)
    Account.where("last_visit_at < '#{DateTime.now - period}' and email is not null").each do |account|
      digest = {
        invitations: account.notification_messages.where(:state => "unread"),
        private_messages: private_messages(account, period),
        comment_likes: a,
        comment_answers: a,
        afisha_comments: a,
        discount_comments: a
      }

      NoticeMailer.digest(digest, account) unless account.email.blank?
    end
  end

  def self.invitations(account, period)
    invitations = []
    invite = Invitation.where("invited_id = #{account.id} and invitations.created_at > '#{DateTime.now - period}'")
    invite.each do  |i|
       if i.invite_messages.where(:state => 'unread').any?
         invitations.push i
       end
    end
    invitations
  end

  def self.private_messages(account, period)
    account.private_messages.where("state = 'unread' and created_at > '#{DateTime.now - period}'")
  end

  def self.comment_likes(account, period)
    likes = []
    notifications = NotificationMessage.where("state = 'unread' and " +
                              "messageable_type = 'Vote' and " +
                              "account_id = #{account.id} and " +
                              "created_at > '#{DateTime.now - period}'")
    notifications.each do |n|
      if n.messageable.voteable_type == "Comment"
        likes.push n.messageable
      end
    end
    likes
  end

  def self.comment_answers(account, period)
    comments = []
    notifications = NotificationMessage.where("state = 'unread' and " +
                              "messageable_type = 'Comment' and " +
                              "account_id = #{account.id} and " +
                              "created_at > '#{DateTime.now - period}' and " +
                              "kind = 'reply_on_comment'")
    notifications.each do |n|
      puts n.inspect
      puts n.messageable.parent.inspect
      if n.messageable.parent.present?
        comments.push n.messageable
      end
    end
    comments
  end

  def self.afisha_comments(account, period)
    comments = []
    notifications = NotificationMessage.where("state = 'unread' and " +
                              "messageable_type = 'Comment' and " +
                              "account_id = #{account.id} and " +
                              "created_at > '#{DateTime.now - period}' and " +
                              "kind = 'new_comment'")
    notifications.each do |n|
      if n.messageable.commentable_type == "Afisha"
        comments.push n.messageable
      end
    end
    comments
  end

  def self.discount_comments(account, period)
    comments = []
    notifications = NotificationMessage.where("state = 'unread' and " +
                              "messageable_type = 'Comment' and " +
                              "account_id = #{account.id} and " +
                              "created_at > '#{DateTime.now - period}' and " +
                              "kind = 'new_comment'")
    notifications.each do |n|
      puts n.messageable.commentable_type
      if n.messageable.commentable_type == "Discount"
        comments.push n.messageable
      end
    end
    comments
  end

end
