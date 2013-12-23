# encoding: utf-8

class Ability
  include CanCan::Ability

  def initialize(user, namespace=nil)
    user ||= User.new

    can :index, [Visit, Friend]

    can :manage, :all     if user.is_admin?
    can :manage, :crm     if user.is_admin? || user.is_sales_manager?

    can [:new, :create], Invitation if user.persisted?
    can [:edit, :update, :destroy], Invitation do |invitation|
      invitation.account == user.account
    end

    can [:new, :create], Offer if user.persisted?

    can :manage, Visit do |visit|
      user.persisted? && visit.user == user
    end

    can :manage, Friend do |friend|
      user.persisted? && friend.account == user.account
    end

    can :manage, PrivateMessage do |private_message|
      user.persisted? && (private_message.producer == user.account || private_message.account == user.account)
    end

    can :manage, InviteMessage do |invite_message|
      user.persisted? && (invite_message.invited == user.account || invite_message.account == user.account)
    end

    can [:create, :destroy], Member do |member|
      user.persisted? && member.account == user.account
    end

    can :read, SmsClaim if user.is_sales_manager?

    case namespace
    when 'manage'
      can :manage, Afisha if user.is_afisha_editor?
      can :manage, Post   if user.is_posts_editor?

      if user.is_organizations_editor?
        can :manage, [Organization] + Organization.available_suborganization_classes
      end
    when 'my'
      can :show, Account do |account|
        user.account == account
      end

      can [:index, :archive, :new, :create, :available_tags, :preview_video], Afisha if user.persisted?

      can [:edit, :update, :destroy_image], Afisha do |afisha|
        afisha.state != 'pending' && afisha.user == user
      end

      can [:destroy, :send_to_published], Afisha do |afisha|
        afisha.draft? && afisha.user == user
      end

      can [:send_to_draft], Afisha do |afisha|
        afisha.published? && afisha.user == user
      end

      can :show, Afisha do |afisha|
        afisha.user == user
      end

      can :send_to_published, Afisha if user.is_afisha_trusted_editor?


      can :manage, GalleryFile do |gallery_file|
        gallery_file.attachable.state != 'pending' && gallery_file.attachable.user == user
      end

      can :social_gallery, Afisha do |afisha|
        afisha.state != 'pending' && afisha.user == user
      end

      can [:new, :create, :index, :edit, :update], GalleryImage if user.persisted?

      can [:destroy, :destroy_all], GalleryImage do |gallery_image|
        if gallery_image.attachable.class.name == 'Account'
          gallery_image.attachable.users.first == user
        else
          gallery_image.attachable.state != 'pending' && gallery_image.attachable.user == user
        end
      end

      can [:destroy, :destroy_all], GallerySocialImage do |gallery_social_image|
        gallery_social_image.attachable.state != 'pending' && gallery_social_image.attachable.user == user
      end

      can :manage, Showing do |showing|
        showing.afisha.state != 'pending' && showing.afisha.user == user
      end

      can [:help, :new, :create, :index], Discount if user.persisted?

      can [:show, :edit, :update, :destroy, :poster], Discount do |discount|
        discount.account == user.account
      end

      can :send_to_published, Discount do |discount|
        discount.draft? && discount.account == user.account
      end

      can :send_to_draft, Discount do |discount|
        discount.published? && discount.account == user.account
      end

      can [:new, :create, :index, :available_tags, :preview, :link_with], Post if user.persisted?
      can [:show, :edit, :update, :destroy, :poster], Post do |post|
        post.account == user.account
      end

      can :send_to_published, Post do |post|
        post.draft? && post.account == user.account
      end

      can :send_to_draft, Post do |post|
        post.published? && post.account == user.account
      end

      can [:new, :create], Invitation if user.persisted?
      can :destroy, Invitation do |invitation|
        invitation.account == user.account
      end

      can [:new, :create], PrivateMessage if user.persisted?
      can [:create], InviteMessage if user.persisted?

    when 'crm'
      return false if user.new_record?

      can :manage, Organization do |organization|
        organization.manager.nil? || user.manager_of?(organization)
      end

      can :manage, Activity do |activity|
        user.manager_of?(activity.organization)
      end

      can :manage, Contact do |contact|
        user.manager_of?(contact.organization)
      end

      can :manage, Reservation do |reservation|
        user.manager_of? reservation.reserveable.organization
      end
    end
  end
end
