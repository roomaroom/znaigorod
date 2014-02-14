# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Specify a custom renderer if needed.
  # The default renderer is SimpleNavigation::Renderer::List which renders HTML lists.
  # The renderer can also be specified as option in the render_navigation call.
  # navigation.renderer = Your::Custom::Renderer

  # Specify the class that will be applied to active navigation items. Defaults to 'selected'
  # navigation.selected_class = 'your_selected_class'

  # Specify the class that will be applied to the current leaf of
  # active navigation items. Defaults to 'simple-navigation-active-leaf'
  # navigation.active_leaf_class = 'your_active_leaf_class'

  # Item keys are normally added to list items as id.
  # This setting turns that off
  # navigation.autogenerate_item_ids = false

  # You can override the default logic that is used to autogenerate the item ids.
  # To do this, define a Proc which takes the key of the current item as argument.
  # The example below would add a prefix to each key.
  navigation.id_generator = Proc.new {|key| "main_menu_#{key}"}

  # If you need to add custom html around item names, you can define a proc that will be called with the name you pass in to the navigation.
  # The example below shows how to wrap items spans.
  # navigation.name_generator = Proc.new {|name| "<span>#{name}</span>"}

  # The auto highlight feature is turned on by default.
  # This turns it off globally (for the whole plugin)
  # navigation.auto_highlight = false

  # Define the primary navigation

  navigation.items do |primary|

    primary.item :afisha, 'Афиша', afisha_index_path, highlights_on: -> { params[:controller] == 'afishas' } do |afisha|
      Afisha.kind.values.each do |item|
        afisha.item "afisha_#{item}", I18n.t("enumerize.afisha.kind.#{item}") ,send("#{item.pluralize}_path")
      end
    end

    primary.item :organizations, 'Заведения', organizations_path,
      highlights_on: -> { %w[organizations suborganizations saunas].include? controller.class.name.underscore.split("_").first } do |organization|
      Organization.suborganization_kinds_for_navigation.drop(1).each do |suborganization_kind|
        organization.item suborganization_kind, I18n.t("organization.kind.#{suborganization_kind}"), send("#{suborganization_kind.pluralize}_path") do |category|
          "#{suborganization_kind.pluralize}_presenter".camelize.constantize.new.categories_links.each do |link|
            category.item "#{suborganization_kind}_#{link[:klass]}", link[:title], send(link[:url])
          end
        end
      end
    end

    primary.item :discounts, 'Скидки', discounts_path, highlights_on: -> { params[:controller] == 'discounts' } do |discount|
      Discount.kind.values.each do |item|
        discount.item "discounts_#{item}", I18n.t("enumerize.discount.kind.#{item}"), send("discounts_#{item}_path")
      end
    end

    primary.item :posts, 'Обзоры', posts_path, highlights_on: -> { params[:controller] == 'posts' } do |post|
      Post.categories.values.each do |item|
        post.item "posts_#{item}_path", I18n.t("enumerize.post.categories.#{item}"), send("posts_#{item}_path")
      end
    end

    primary.item :accounts, 'Знакомства', accounts_path, highlights_on: -> { params[:controller] == 'accounts' } do |account|
      Inviteables.instance.categories.keys.each do |item|
        account.item Russian::translit(item).gsub(/\s|\//, '_'), item, send("accounts_#{(transliterate(item))}_path")
      end
    end

    primary.item :more, 'Ещё', '#', :link => { :class => :disabled },
      highlights_on: -> { %w[contests posts works cooperation].include?(params[:controller]) } do |more|
      more.item :tickets, 'Распродажа билетов', afisha_with_tickets_index_path, highlights_on: -> { params[:controller] == nil }
      more.item :webcams, 'Веб-камеры', webcams_path, highlights_on: -> { params[:controller] == 'webcams' }
      more.item :contests, 'Конкурсы', contests_path, highlights_on: -> { %w[contests works].include? params[:controller] }
      more.item :services, 'Реклама', services_path, highlights_on: -> { params[:controller] == 'cooperation' }
      more.item :widgets, 'Виджеты', widgets_root_path, highlights_on: -> { params[:controller].match /widgets/i }
      more.item :feedback, 'Отзывы и предложения', feedback_path, highlights_on: -> { params[:controller] == 'feedback' }
    end

    # Add an item to the primary navigation. The following params apply:
    # key - a symbol which uniquely defines your navigation item in the scope of the primary_navigation
    # name - will be displayed in the rendered navigation. This can also be a call to your I18n-framework.
    # url - the address that the generated item links to. You can also use url_helpers (named routes, restful routes helper, url_for etc.)
    # options - can be used to specify attributes that will be included in the rendered navigation item (e.g. id, class etc.)
    #           some special options that can be set:
    #           :if - Specifies a proc to call to determine if the item should
    #                 be rendered (e.g. <tt>:if => Proc.new { current_user.admin? }</tt>). The
    #                 proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :unless - Specifies a proc to call to determine if the item should not
    #                     be rendered (e.g. <tt>:unless => Proc.new { current_user.admin? }</tt>). The
    #                     proc should evaluate to a true or false value and is evaluated in the context of the view.
    #           :method - Specifies the http-method for the generated link - default is :get.
    #           :highlights_on - if autohighlighting is turned off and/or you want to explicitly specify
    #                            when the item should be highlighted, you can set a regexp which is matched
    #                            against the current URI.  You may also use a proc, or the symbol <tt>:subpath</tt>.
    #
    # Add an item which has a sub navigation (same params, but with block)
    # primary.item :key_2, 'name', url, options do |sub_nav|
    # # Add an item to the sub navigation (same params again)
    # # sub_nav.item :key_2_1, 'name', url, options
    # end

    # You can also specify a condition-proc that needs to be fullfilled to display an item.
    # Conditions are part of the options. They are evaluated in the context of the views,
    # thus you can use all the methods and vars you have available in the views.
    # primary.item :key_3, 'Admin', url, :class => 'special', :if => Proc.new { current_user.admin? }
    # primary.item :key_4, 'Account', url, :unless => Proc.new { logged_in? }

    # you can also specify a css id or class to attach to this particular level
    # works for all levels of the menu
    # primary.dom_id = 'menu-id'
    # primary.dom_class = 'menu-class'

    # You can turn off auto highlighting for a specific level
    # primary.auto_highlight = false

  end
end