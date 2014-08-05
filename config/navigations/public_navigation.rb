SimpleNavigation::Configuration.run do |navigation|
  navigation.id_generator = Proc.new {|key| "main_menu_#{key}"}

  navigation.items do |primary|
    primary.item :afisha, 'Афиша', afisha_index_path, highlights_on: -> { controller_name == 'afishas' } do |afisha|
      afisha.noindex = true

      Afisha.kind.values.each do |item|
        afisha.item "afisha_#{item}", I18n.t("enumerize.afisha.kind.#{item}") ,send("#{item.pluralize}_path"), :link => { :rel => :nofollow }
      end
    end

    primary.item :questions, 'Спрашивай', questions_path, highlights_on: -> { controller_name == 'questions' } do |questions|
      questions.noindex = true

      Hash[Question.categories.options].invert.each do |category, title|
        questions.item category, title, [:questions, category], :link => { :rel => :nofollow }
      end
    end

    primary.item :organizations, 'Заведения', organizations_path,
      highlights_on: -> { %w[organizations suborganizations saunas].include? controller.class.name.underscore.split("_").first } do |organization|
      organization.noindex = true

      Organization.suborganization_kinds_for_navigation.drop(1).each do |suborganization_kind|
        organization.item suborganization_kind, I18n.t("organization.kind.#{suborganization_kind}"), send("#{suborganization_kind.pluralize}_path"), :class => suborganization_kind  do |category|
          "#{suborganization_kind.pluralize}_presenter".camelize.constantize.new.categories_links.each do |link|
            category.item "#{suborganization_kind}_#{link[:klass]}", link[:title], send(link[:url]), :link => { :rel => :nofollow }
          end
        end
      end
    end

    primary.item :discounts, 'Скидки', discounts_path, highlights_on: -> { controller_name == 'discounts' } do |discount|
      discount.noindex = true

      Hash[Discount.kind.options].invert.each do |kind, title|
        discount.item kind, title, [:discounts, kind], :link => { :rel => :nofollow }
      end
    end

    primary.item :reviews, 'Обзоры', reviews_path, highlights_on: -> { controller_name == 'reviews' } do |reviews|
      reviews.noindex = true

      Hash[Review.categories.options].invert.each do |category, title|
        reviews.item category, title, [:reviews, category], :link => { :rel => :nofollow }
      end
    end

    primary.item :more, 'Ещё', '#', :link => { :class => :disabled },
      highlights_on: -> { %w[contests works cooperation].include?(controller_name) } do |more|
      more.noindex = true

      more.item :accounts, 'Знакомства', accounts_path, highlights_on: -> { controller_name == 'accounts' }
      more.item :tickets, 'Распродажа билетов', afisha_with_tickets_index_path, highlights_on: -> { controller_name == nil }, :link => { :rel => :nofollow }
      more.item :news_of_tomsk, 'Новости Томска', 'http://news.znaigorod.ru', :link => { :rel => :nofollow }
      more.item :webcams, 'Веб-камеры', webcams_path, highlights_on: -> { controller_name == 'webcams' }, :link => { :rel => :nofollow }
      more.item :contests, 'Конкурсы', contests_path, highlights_on: -> { %w[contests works].include? controller_name }, :link => { :rel => :nofollow }
      more.item :services, 'Реклама', services_path, highlights_on: -> { controller_name == 'cooperation' }, :link => { :rel => :nofollow }
      more.item :widgets, 'Виджеты', widgets_root_path, highlights_on: -> { controller_name.match(/widgets/i) }, :link => { :rel => :nofollow }
      more.item :feedback, 'Отзывы и предложения', feedback_path, highlights_on: -> { controller_name == 'feedback' }, :link => { :rel => :nofollow }
      more.item :questions, 'Спрашивай', questions_path, highlights_on: -> { controller_name == 'q'  }, :link => { :rel => :nofollow }
    end
  end
end
