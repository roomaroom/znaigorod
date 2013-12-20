# encoding: utf-8

class SendPersonalDigest

  class Digest
    attr_accessor :invitations, :private_messages, :comment_likes, :comment_answers, :afisha_comments, :discount_comments

    def initialize(account, period)
      @account = account
      @period = period
      @invitations = get_invitations
      @private_messages = get_private_messages
      @comment_likes = get_comment_likes
      @comment_answers = get_comment_answers
      @afisha_comments = get_afisha_comments
      @discount_comments = get_discount_comments
    end

    def is_blank?
      if @private_messages.blank? && @comment_likes.blank? &&
        @comment_answers.blank? && @afisha_comments.blank? && @discount_comments.blank?
        return true
      else
        return false
      end
    end

    def get_invitations
      invitations = []
      invite = Invitation.where("invited_id = #{@account.id} and invitations.created_at > '#{@account.last_visit_at.to_datetime}'")
      invite.each do  |i|
        if i.invite_messages.where(:state => 'unread').any?
          invitations.push i
        end
      end
      invitations
    end

    def get_private_messages
      @account.private_messages.where("state = 'unread' and created_at > '#{@account.last_visit_at}'")
    end

    def get_comment_likes
      likes = []
      notifications = NotificationMessage.where("state = 'unread' and " +
                                                "messageable_type = 'Vote' and " +
                                                "account_id = #{@account.id} and " +
      "created_at > '#{@account.last_visit_at}'")
      notifications.each do |n|
        if n.messageable.voteable_type == "Comment"
          likes.push n.messageable
        end
      end
      likes
    end

    def get_comment_answers
      comments = []
      notifications = NotificationMessage.where("state = 'unread' and " +
                                                "messageable_type = 'Comment' and " +
                                                "account_id = #{@account.id} and " +
      "created_at > '#{@account.last_visit_at}' and " +
      "kind = 'reply_on_comment'")
      notifications.each do |n|
        if n.messageable.parent.present?
          comments.push n.messageable
        end
      end
      comments
    end

    def get_afisha_comments
      comments = []
      notifications = NotificationMessage.where("state = 'unread' and " +
                                                "messageable_type = 'Comment' and " +
                                                "account_id = #{@account.id} and " +
      "created_at > '#{@account.last_visit_at}' and " +
      "kind = 'new_comment'")
      notifications.each do |n|
        if n.messageable.commentable_type == "Afisha"
          comments.push n.messageable
        end
      end
      comments
    end

    def get_discount_comments
      comments = []
      notifications = NotificationMessage.where("state = 'unread' and " +
                                                "messageable_type = 'Comment' and " +
                                                "account_id = #{@account.id} and " +
      "created_at > '#{@account.last_visit_at}' and " +
      "kind = 'new_comment'")
      notifications.each do |n|
        if n.messageable.commentable_type == "Discount"
          comments.push n.messageable
        end
      end
      comments
    end

  end


  def self.send
    period = 1.day
    Account.where("email is not null and last_visit_at <= '#{DateTime.now - period}'").each do |account|
      digest = Digest.new(account, period)
      PersonalDigestMailer.send_digest(account, digest) unless digest.is_blank?
    end
  end

end
