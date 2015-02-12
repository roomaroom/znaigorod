module OrganizationCategoriesHelper
  def organization_categories(categories = OrganizationCategory.roots)
    return '' if categories.empty?

    content_tag :ul do
      categories.map { |c| content_tag :li, (c.title + organization_categories(c.children)).html_safe }.join.html_safe
    end
  end
end
