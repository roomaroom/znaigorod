# encoding: utf-8

class MealDecorator < SuborganizationDecorator
  decorates :meal

  def characteristics_list(name)
    content = ""
    content << h.content_tag(:li, I18n.t("activerecord.attributes.meal.#{name.singularize}"), class: 'title')
    content << "\n"
    meal.send(name).each do |value|
      content << h.content_tag(:li, h.link_to(value, h.organizations_path(organization_class: 'meals',
                                                                      category: priority_category,
                                                                      query: "#{name}/#{value.mb_chars.downcase}")))
      content << "\n"
    end
    h.content_tag(:ul, content.html_safe)
  end

  def list_info
    %w[categories cuisines].map { |characteristic| characteristics_list(characteristic) if meal.send(characteristic).any? }.join("\n").html_safe
  end

  def info
    %w[categories cuisines].map { |characteristic| characteristics_list(characteristic) if meal.send(characteristic).any? }.join("\n").html_safe
  end

  def priority_category
    categories.first.mb_chars.downcase
  end
end
