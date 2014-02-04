class AutoHtmlRenderer
  include AutoHtml

  attr_accessor :text, :allow_external_links

  def initialize(text = nil, allow_external_links: true)
    @text, @allow_external_links = text, allow_external_links
  end

  def apply_auto_html(str, options = {})
    allow_external_links ? auto_html_with_away_links(str, options) : auto_html_without_away_links(str, options)
  end

  def render_show(options = {})
    apply_sanitize(apply_auto_html(text, options)).html_safe
  end

  def render_index(length=180)
    remove_tags(apply_auto_html(text)).to_s.truncate(length, :separator => ' ')
  end

  def youtube
    auto_html(text) { youtube :width => 700 }
  end

  private

  def auto_html_with_away_links(str, options = {})
    auto_html(str) do
      youtube options[:youtube] || { :width => 700 }
      vimeo options[:vimeo] || { :width => 700 }
      redcloth
    end
  end

  def auto_html_without_away_links(str, options = {})
    auto_html(str) do
      youtube options[:youtube] || { :width => 700 }
      vimeo options[:vimeo] || { :width => 700 }
      redcloth
      away_links
    end
  end

  def apply_sanitize(str)
    Sanitize.clean(
      str,
      :elements => ['a', 'img', 'p', 'div', 'h2', 'h3', 'strong', 'em', 'ul', 'ol', 'li', 'iframe'],
      :attributes => {
        :all => ['src', 'alt', 'title', 'href', 'width', 'height', 'frameborder', 'allowfullscreen', 'target', 'rel']
      }
    )
  end

  def remove_tags(str)
    Sanitize.clean(str, :elements => [])
  end
end
