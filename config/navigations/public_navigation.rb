SimpleNavigation::Configuration.run do |navigation|
  navigation.id_generator = Proc.new {|key| "main_menu_#{key}"}

  navigation.items do |primary|
    primary.item :afisha, 'Афиша', afisha_index_url(subdomain: false), highlights_on: -> { controller_name == 'afishas' } do |afisha|

      Afisha.kind.values.each do |item|
        afisha.item "afisha_#{item}", I18n.t("enumerize.afisha.kind.#{item}"), send("#{item.pluralize}_url", subdomain: false)
      end
    end

    primary.item :questions, 'Спрашивай', questions_url(subdomain: false), highlights_on: -> { controller_name == 'questions' } do |questions|

      Hash[Question.categories.options].invert.each do |category, title|
        questions.item category, title, send("questions_#{category}_url", subdomain: false) #[:questions, category]
      end
    end

    primary.item :organizations, 'Заведения', organizations_url(subdomain: false),
      highlights_on: -> { %w[organizations suborganizations saunas].include? controller.class.name.underscore.split("_").first } do |organization|

      Organization.suborganization_kinds_for_navigation.drop(1).each do |suborganization_kind|
        organization.item suborganization_kind, I18n.t("organization.kind.#{suborganization_kind}"), send("#{suborganization_kind.pluralize}_url", subdomain: false), :class => suborganization_kind  do |category|
          "#{suborganization_kind.pluralize}_presenter".camelize.constantize.new.categories_links.each do |link|
            category.item "#{suborganization_kind}_#{link[:klass]}", link[:title], send(link[:url], subdomain: false)
          end
        end
      end
    end

    primary.item :discounts, 'Скидки', discounts_url(subdomain: 'discounts'), highlights_on: -> { controller_name == 'discounts' } do |discount|

      Hash[Discount.kind.options].invert.each do |kind, title|
        discount.item kind, title, send("#{kind}_url", subdomain: 'discounts') # [:discounts, kind]
      end
    end

    primary.item :reviews, 'Обзоры', reviews_url(subdomain: false), highlights_on: -> { controller_name == 'reviews' } do |reviews|

      Hash[Review.categories.options].invert.each do |category, title|
        reviews.item category, title, send("reviews_#{category}_url", subdomain: false)# [:reviews, category]
      end
    end

    primary.item :more, 'Ещё', '#', :link => { :class => :disabled },
      highlights_on: -> { %w[contests works cooperation].include?(controller_name) } do |more|

      more.item :photogalleries, 'Фотогалереи', photogalleries_url(subdomain: false), highlights_on: -> { controller_name == 'photogalleries' }
      more.item :accounts, 'Знакомства', accounts_url(subdomain: false), highlights_on: -> { controller_name == 'accounts' }
      more.item :tickets, 'Распродажа билетов', afisha_with_tickets_index_url(subdomain: false), highlights_on: -> { controller_name == nil }
      more.item :news_of_tomsk, 'Новости Томска', 'http://news.znaigorod.ru'
      more.item :webcams, 'Веб-камеры', webcams_url(subdomain: false), highlights_on: -> { controller_name == 'webcams' }
      more.item :contests, 'Конкурсы', contests_url(subdomain: false), highlights_on: -> { %w[contests works].include? controller_name }
      more.item :services, 'Реклама', services_url(subdomain: false), highlights_on: -> { controller_name == 'cooperation' }
      more.item :widgets, 'Виджеты', widgets_root_url(subdomain: false), highlights_on: -> { controller_name.match(/widgets/i) }
      more.item :feedback, 'Отзывы и предложения', feedback_url(subdomain: false), highlights_on: -> { controller_name == 'feedback' }
      more.item :questions, 'Спрашивай', questions_url(subdomain: false), highlights_on: -> { controller_name == 'q'  }
    end
  end
end
