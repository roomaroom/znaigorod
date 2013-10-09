# encoding: utf-8

module AccountHelper

  def invitations_for_tipsy(invitations)
    content = ''
    if invitations.inviter.without_invited.any?
      invitations.inviter.without_invited.each do |invitation|
        content += '<p>'
        content += 'Приглашает'
        content += ' '
        content += t("enumerize.invitation.gender.custom.#{invitation.kind}.#{invitation.gender}")
        content += ' '
        if invitation.inviteable
          content += Preposition.new(invitation.inviteable).value
          content += ' '
          content += invitation.inviteable.title
        else
          content += invitation.category
        end
        content += '</p>'
      end
    end
    if invitations.invited.without_invited.any?
      invitations.invited.without_invited.each do |invitation|
        content += '<p>'
        content += 'Ждет приглашения'
        content += ' '
        content += t("enumerize.invitation.gender.custom.#{invitation.kind}.#{invitation.gender}")
        content += ' '
        if invitation.inviteable
          content += Preposition.new(invitation.inviteable).value
          content += ' '
          content += invitation.inviteable.title
        else
          content += invitation.category
        end
        content += '</p>'
      end
    end
    content.present? ? content : 'Приглашает или ждет приглашения'
  end

end
