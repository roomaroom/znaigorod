# encoding: utf-8

module EmailDigestHelper

  def path_for_email(obj, anchor = nil )
    obj = obj.model if obj.class.name.underscore.match(/decorator/)
    method = "#{obj.class.name.underscore}_path"
    method = "discount_path" if %[Discount Coupon Certificate OfferedDiscount AffiliatedCoupon].include?(obj.class.name)


    send(method,
         obj,
         :anchor => anchor,
         :only_path => false,
         :utm_campaign => "znaigorod",
         :utm_medium => "email",
         :utm_source => "email")
  end

  def croped_image_url_for_email(url, ratio)
    url.gsub(/(\/region\/(\d+|\/)\/(\d+|\/))/) { "/region/#{$2}/#{($3.to_i - $3.to_i*ratio).to_i}" }
  end

  def invitations_for_account(account)
    invitations = account.invitations
    content = ''
    if invitations.inviter.without_invited.any?
      content += 'Приглашает'
      content += ' '
      invitations.inviter.without_invited.each do |invitation|
        if invitation.inviteable
          content += t("enumerize.invitation.gender.custom.#{invitation.kind}.#{invitation.gender}")
          content += ' '
          content += Preposition.new(invitation.inviteable).value
          content += ' '
          content += invitation.inviteable.title
        else
          content += t("enumerize.invitation.gender.custom.#{invitation.kind}.#{invitation.gender}")
          content += ' '
          content += invitation.category
        end
        content += ', '
      end
    end
    if invitations.invited.without_invited.any? && content.empty?
      content += 'Ждет приглашения'
      content += ' '
      invitations.invited.without_invited.each do |invitation|
        if invitation.inviteable
          content += t("enumerize.invitation.gender.custom.#{invitation.kind}.#{invitation.gender}")
          content += ' '
          content += Preposition.new(invitation.inviteable).value
          content += ' '
          content += invitation.inviteable.title
        else
          content += t("enumerize.invitation.gender.custom.#{invitation.kind}.#{invitation.gender}")
          content += ' '
          content += invitation.category
        end
        content += ', '
      end
    end
    content.present? ? truncate(content[0..-3], length: 55) : 'Приглашает или ждет приглашения'
  end

  def places_for_afisha(afisha, only_text = false)
    max_lenght = 23
    place_output = ""
    places = afisha.places
    places.each_with_index do |place, index|
      place_title = place.organization ? place.organization.title : place.title
      place_link_title = place_title.dup
      place_title = place_title.gsub(/,.*/, '')
      place_title = place_title.truncate(max_lenght, :separator => ' ')
      max_lenght -= place_title.size
      # NOTICE hell
      if only_text
        if place.organization
          place_output += place_title.text_gilensize +
                          "(" +
                          organization_path(place.organization,
                                            :only_path => false,
                                            :utm_campaign => "znaigorod",
                                            :utm_medium => "email",
                                            :utm_source => "email") +
                          " )"
        else
          place_output += place_link_title.blank? ? place_title.text_gilensize : place_link_title.text_gilensize
        end
      else
        if place.organization
          place_output += link_to(place_title.text_gilensize,
                                  organization_path(place.organization,
                                                    :only_path => false,
                                                    :utm_campaign => "znaigorod",
                                                    :utm_medium => "email",
                                                    :utm_source => "email"),
                                  :title => place_link_title.text_gilensize)
        else
          place_output += place_link_title.blank? ? place_title.text_gilensize : content_tag(:abbr, place_title.text_gilensize, :title => place_link_title.text_gilensize)
        end
      end
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    raw place_output
  end

  def site_digest_text(collection, account)
    result = "ЗнайГород\n\n"
    result << t("notice_mailer.#{@type}") + "\n\n"
    result << t("notice_mailer.#{@type}_text_description") + "\n\n"
    collection.each do |materials|
      result << "="*60 << "\n\n"

      result << t("notice_mailer.afisha_title") + "\n\n" if materials.first.is_a?(Afisha)
      result << t("notice_mailer.organization_title") + "\n\n" if materials.first.is_a?(Organization)
      result << t("notice_mailer.discount_title") + "\n\n" if materials.first.is_a?(Discount)
      result << t("notice_mailer.account_title") + "\n\n" if materials.first.is_a?(Array)

      unless materials.blank?
        unless materials.first.is_a?(Array)
          materials.each_with_index do |material, index|
            result << afisha_text(material) + "\n\n" if materials.first.is_a?(Afisha)
            result << discount_text(material) + "\n\n" if materials.first.is_a?(Discount)
            result << organization_text(material) + "\n\n" if materials.first.is_a?(Organization)
          end
        else
          result << account_text(materials, account) + "\n\n" unless account.gender == 'undefined'
        end
      end
    end

    result
  end

  def afisha_text(afisha)
    result = ""
    afisha = AfishaDecorator.new afisha

    result << afisha.title.text_gilensize
    result << "(" + path_for_email(afisha) + " )\n"

    if afisha.has_tickets_for_sale?
      result << t("notice_mailer.buy_ticket")
      result << "(" + path_for_email(afisha, :buy_ticket) + " )\n"
    end

    result << places_for_afisha(afisha, true) + "\n"

    result <<  afisha.human_when.replace_special_html_chars if afisha.human_when

    result
  end

  def discount_text(discount)
    result = ""
    result << discount.title.text_gilensize
    result << "(" + path_for_email(discount) + " )\n"

    unless discount.is_a?(AffiliatedCoupon)

      if discount.is_a?(OfferedDiscount)
        result << t("notice_mailer.my_price")
        result << " (" + path_for_email(discount, :offer_price) + " )\n"
      else
        unless discount.price.present? && discount.price.zero?
          result << t("notice_mailer.buy")
          result << " (" + path_for_email(discount, :buy_ticket) + " )\n"
        end
      end

    else

      if discount.price.nil? || discount.price.zero?
        #NOTICE this is for pricupon
        result << t("notice_mailer.get")
      else
        #NOTICE this is for pricupon
        result << t("notice_mailer.buy")
      end
      result << " (" + discount.supplier.try(:link) + " )\n"

    end

    unless discount.places.empty?
      place = discount.places.first
      if place.organization_id?
        result << place.organization.try(:title)
        result << " (" + path_for_email(place.organization) + " )"
      else
        result << place.address
      end
    end

    result << certificate_info_text(discount) if discount.is_a?(Certificate)

    result
  end

  def certificate_info_text(discount)
    result = "\nСкидка" + " - "
    result << discount.discount.to_s + "%"

    result
  end

  def organization_text(organization)
    result = ""

    result << organization.title.text_gilensize
    result << " (" + path_for_email(organization) + " )\n"

    if organization.is_a?(Organization)
      if organization.sms_claimable?
        result << organization.priority_sms_claimable_suborganization.reservation_title
        result << " (" + send("new_#{organization.priority_sms_claimable_suborganization.class.name.underscore}_sms_claim_path",
             organization.priority_sms_claimable_suborganization,
             :only_path => false,
             :utm_campaign => "znaigorod",
             :utm_medium => "email",
             :utm_source => "email") + " ) "

      end
    else
      if organization.organization.sms_claimable?
        result << send("new_#{organization.class.name.underscore}_sms_claim_path",
             organization.organization,
             :only_path => false,
             :utm_campaign => "znaigorod",
             :utm_medium => "email",
             :utm_source => "email")

      end
    end

    unless organization.address.to_s.blank?
      result << "#{organization.address}#{organization.office}" + "\n"
    end

    result << ( organization.phone.blank? ? "  " : organization.phone.squish.split(', ').first )

    result
  end

  def account_text(materials, account)
    result = ""

    materials = materials.first if account.gender == 'male'
    materials = materials.second if account.gender == 'female'

    materials.each_with_index do |material, index|
      result << material.title + "\n"
      result << path_for_email(material) + "\n"

      if material.invitations.without_invited.any?
        if material.invitations.inviter.without_invited.any?
          result << path_for_email(material, 'invite_me') + "\n"
          result << t("notice_mailer.invite_me") + "\n"
        elsif material.invitations.invited.without_invited.any?
          result << path_for_email(material, 'invite_me') + "\n"
          result << t("notice_mailer.invite") + "\n"
        end
      end
      result << invitations_for_account(material) + "\n\n"
    end

    result
  end

  def personal_digest_text(digest, account)
    result = "ЗнайГород\n\n"
    digest.each do |materials|
      unless materials.blank?

        result << "="*60 + "\n\n"

        if %w[Invitation PrivateMessage Vote].include?(materials.first.class.name)
          result << t("notice_mailer.#{materials.first.class.name.underscore}_title") + "\n\n"
        elsif materials.first.is_a?(Comment)
          if materials.map(&:parent).all? { |i| i.present? }
            result << t("notice_mailer.answered_on_you_comment") + "\n\n"
          elsif materials.first.commentable.is_a?(Afisha) || materials.first.commentable.is_a?(Discount)
            result << t("notice_mailer.materials_comment") + "\n\n"
          end
        end
        materials.each do |material|
          result << send("#{ material.class.name.underscore }_personal_text", material)
        end

      end
    end

    result
  end

  def comment_personal_text(comment)
    result = ""

    if comment.parent.present?
      result << answer_comment_personal_text(comment) + "\n"
    elsif comment.commentable.is_a?(Afisha)
      result << afisha_comment_personal_text(comment) + "\n"
    elsif comment.commentable.is_a?(Discount)
      result << discount_comment_personal_text(comment) + "\n"
    end

    result
  end

  def afisha_comment_personal_text(comment)
    result = ""

    result << path_for_email(comment.user.account) + "\n"
    result << comment.user.account.title + "\n"

    result << t("notice_mailer.at") + "\n"

    result << comment.commentable.title + " ( "
    result << path_for_email(comment.commentable) + ")\n"
    result << comment.body.truncated + "\n" if comment.body?

    if comment.commentable.is_a?(Afisha)
      result << t("notice_mailer.answer") + " ("
      result << path_for_email(comment.commentable, "answer_#{comment.id}") + " )\n"
    end

    result
  end

  def answer_comment_personal_text(comment)
    result = ""

    result << comment.user.account.title
    result << " (" + path_for_email(comment.user.account) + " )\n"
    result << l(comment.created_at, format: "%d %B %Y, %k:%M") + "\n"
    result << t("notice_mailer.answered") + "\n"
    result << comment.body.truncated + "\n" if comment.body?
    result << t("notice_mailer.on_your_comment") + "\n"
    result << comment.parent.body.truncated + "\n" if comment.body?
    result << t("notice_mailer.at") + "\n"
    if comment.commentable.is_a?(Work)
      if comment.commentable.title.present?
        result << comment.commentable.title + " ("
        result << contest_work_path(comment.commentable.contest,
                                    comment.commentable,
                                    :only_path => false,
                                    :utm_campaign => "znaigorod",
                                    :utm_medium => "email",
                                    :utm_source => "email") + " )\n"
      else
        result << comment.commentable.slug + "\n"
        result << contest_work_path(comment.commentable.contest,
                                    comment.commentable,
                                    :only_path => false,
                                    :utm_campaign => "znaigorod",
                                    :utm_medium => "email",
                                    :utm_source => "email") + " )\n"
      end
    end
    %w[afisha discount organization post].each do |item|
      if comment.commentable.is_a?(item.camelize.constantize)
        result << comment.commentable.title
        result << " (" + send("#{item}_path",
                       comment.commentable,
                       :only_path => false,
                       :utm_campaign => "znaigorod",
                       :utm_medium => "email",
                       :utm_source => "email") + " )\n"
      end
    end


    if comment.commentable.is_a?(Work)
      result << t("notice_mailer.answer")
      result << " (" + contest_work_path(comment.commentable.contest,
                                  comment.commentable,
                                  :only_path => false,
                                  :anchor => "answer_#{comment.id}",
                                  :utm_campaign => "znaigorod",
                                  :utm_medium => "email",
                                  :utm_source => "email") + " )\n "
    end

    %w[afisha discount organization post].each do |item|
      if comment.commentable.is_a?(item.camelize.constantize)
        result << t("notice_mailer.answer")
        result << " (" + send("#{item}_path",
                       comment.commentable,
                       :only_path => false,
                       :anchor => "answer_#{comment.id}",
                       :utm_campaign => "znaigorod",
                       :utm_medium => "email",
                       :utm_source => "email") + " )\n "
      end
    end

    result
  end

  def discount_comment_personal_text(comment)
    result = ""
    result << comment.user.account.title + " ("
    result << path_for_email(comment.user.account) + " )\n"

    result << l(comment.created_at, format: "%d %B %Y, %k:%M") + "\n"
    result << t("notice_mailer.at") + "\n"
    result << comment.commentable.title + " ("
    result << path_for_email(comment.commentable) + " )\n"
    result << comment.body.truncated + "\n" if comment.body?
    if comment.commentable.is_a?(Discount)
      result << t("notice_mailer.answer") + " ("
      result << path_for_email(comment.commentable, "answer_#{comment.id}") + " )\n"
    end

    result
  end

  def vote_personal_text(vote)
    result = ""

    result << vote.user.account.title + " ("
    result << path_for_email(vote.user.account) + " )\n"
    result << l(vote.created_at, format: "%d %B %Y, %k:%M") + "\n"
    result << t("notice_mailer.liked_your_comment.#{vote.user.account.gender}") + "\n"
    result << vote.voteable.body.truncated + "\n" if vote.voteable.body?
    result << t("notice_mailer.at") + "\n"
    if vote.voteable.commentable.is_a?(Work)
      if vote.voteable.commentable.title.present?
        result << vote.voteable.commentable.title + " ("
        result << contest_work_path(vote.voteable.commentable.contest, vote.voteable.commentable, :only_path => false, :utm_campaign => "znaigorod", :utm_medium => "email", :utm_source => "email") + " )\n"
      else
        result << vote.voteable.commentable.slug + " ("
        result << contest_work_path(vote.voteable.commentable.contest, vote.voteable.commentable, :only_path => false, :utm_campaign => "znaigorod", :utm_medium => "email", :utm_source => "email") + " )\n"
      end
    end
    %w[afisha discount organization post].each do |item|
      if vote.voteable.commentable.is_a?(item.camelize.constantize)
        result << vote.voteable.commentable.title + " ("
        result << send("#{item}_path", vote.voteable.commentable, :only_path => false, :utm_campaign => "znaigorod", :utm_medium => "email", :utm_source => "email") + " )\n"
      end
    end
    result << "\n"

    result
  end

  def invitation_personal_text(invitation)
    result = ""

    result << invitation.account.title + " ("
    result << path_for_email(invitation.account) + " )\n"
    result << t("notice_mailer.is_invite_you_at") + " "

    if invitation.category.blank?
      result << t("notice_mailer.at") + "\n"
      result << invitation.inviteable.title + " ("
      result << path_for_email(invitation.inviteable) + " )\n"
    else
      result << invitation.category + "\n"
    end

    result << l(invitation.created_at, format: "%d %B %Y, %k:%M") + "\n"

    result << t("notice_mailer.accept_invite") + " ("
    result << my_invite_messages_path(:only_path => false, :utm_campaign => "znaigorod",
                            :utm_medium => "email", :utm_source => "email",
                            :anchor => "accept_invite_#{invitation.invite_messages.first.id}") + " )\n"

    result << t("notice_mailer.abandon_invite") + " ("
    result << my_invite_messages_path(:only_path => false, :utm_campaign => "znaigorod",
                            :utm_medium => "email", :utm_source => "email",
                            :anchor => "abandon_invite_#{invitation.invite_messages.first.id}") + " )\n"

    result << t("notice_mailer.to_invitations") + " ("
    result << my_invite_messages_path(:only_path => false, :utm_campaign => "znaigorod",
                            :utm_medium => "email", :utm_source => "email") + " )\n\n"

    result
  end

  def private_message_personal_text(private_message)
    result = ""

    result << private_message.producer.title + " ("
    result << path_for_email(private_message.producer) + " )\n"
    result << private_message.producer.title + "\n"
    result << l(private_message.created_at, format: "%d %B %Y, %k:%M") + "\n"
    result << private_message.body + "\n"
    result << t("notice_mailer.to_dialog") + " ("
    result << my_dialogs_path(:only_path => false,
                    :anchor => "dialog_#{private_message.producer.id}",
                    :utm_campaign => "znaigorod",
                    :utm_medium => "email",
                    :utm_source => "email") + " )\n\n"

    result
  end

end
