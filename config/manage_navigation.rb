# -*- coding: utf-8 -*-

SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|

    primary.item :comments, 'Комментарии', manage_comments_path, :if => -> { can?(:manage, Comment) }

    primary.item :users, 'Пользователи', manage_admin_users_path,
      :highlights_on => ->(){ controller_name == 'users' || resource_class.try(:superclass) == User },
      :if => -> { can?(:manage, User) }

    primary.item :organisations, 'Заведения', manage_organizations_path,
      :highlights_on => ->(){ (controller_name == 'organizations' || resource_class.try(:superclass) == Organization) && namespace != 'crm'},
      :if => -> { can?(:manage, Organization) } do |org_item|
        Organization.available_suborganization_classes.each do |klass|
          org_item.item klass, klass.model_name.human, [:manage, klass.model_name.underscore.pluralize]
        end

        org_item.item :rated, 'Рейтинг организаций', manage_organizations_rated_path
    end

    primary.item :afisha, 'Мероприятия', manage_afisha_index_path,
      :highlights_on => ->(){ controller_name == 'afisha' },
      :if => -> { can?(:manage, Afisha) } do |afisha_item|
        Afisha.kind.values.each do |kind|
          afisha_item.item kind, kind.text, by_kind_manage_afisha_index_path(kind.pluralize)
        end
        afisha_item.item 'draft', "Черновики (#{Afisha.draft.count})", by_state_manage_afisha_index_path(:draft)
    end

    primary.item :posts, 'Купоны', manage_discounts_path,
      :highlights_on => ->(){ resource_class == Discount || resource_class == Coupon || resource_class == Certificate },
      :if => -> { can?(:manage, Discount) } do |discount_item|
        Discount.kind.values.each do |kind|
          discount_item.item kind, kind.text, by_kind_manage_discounts_path(kind.pluralize)
        end
        discount_item.item 'draft', "Черновики (#{Discount.draft.count})", by_state_manage_discounts_path(:draft)
      end

    primary.item :posts, 'Конкурсы', manage_contests_path,
      :highlights_on => ->(){ resource_class == Contest },
      :if => -> { can?(:manage, Contest) }

    primary.item :posts, 'Посты', manage_posts_path,
      :highlights_on => ->(){ resource_class == Post },
      :if => -> { can?(:manage, Post) }

    primary.item :statistics, 'Статистика' do |statistics_item|
      statistics_item.item :payments, 'Платежи', manage_statistics_payments_path
      statistics_item.item :invitations, 'Приглашения', manage_invitations_path
      statistics_item.item :discount_with_prices, 'Купоны', manage_discount_statistics_path
      statistics_item.item :sms_claims, 'Смс заявки', manage_statistics_sms_claims_path
    end

    primary.item :crm, 'ЦРМ', crm_root_path,
      :highlights_on => ->(){ namespace == 'crm' },
      :if => -> { can?(:manage, :crm) } do |crm_item|
        [Organization, Activity].each do |kind|
          crm_item.item kind, kind.model_name.human, [:crm, kind.model_name.underscore.pluralize]
        end
        crm_item.item 'meetings', 'План встреч', [:meetings, :crm, :activities]
    end

    primary.item :tickets, 'Билеты', manage_tickets_path
    primary.item :payments, 'Вебкамеры', manage_webcams_path
    # primary.item :offers, 'Предложения цены', manage_offers_path

    primary.dom_class = 'navigation'
  end
end
