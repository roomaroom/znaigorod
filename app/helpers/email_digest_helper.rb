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

  def places_for_afisha(afisha)
    max_lenght = 23
    place_output = ""
    places = afisha.places
    places.each_with_index do |place, index|
      place_title = place.organization ? place.organization.title : place.title
      place_link_title = place_title.dup
      place_title = place_title.gsub(/,.*/, '')
      place_title = place_title.truncate(max_lenght, :separator => ' ')
      max_lenght -= place_title.size
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
      break if max_lenght < 3
      place_output += ", " if index < places.size - 1
    end
    raw place_output
  end


end
