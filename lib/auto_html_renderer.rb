class AutoHtmlRenderer
  include AutoHtml

  attr_accessor :text

  def initialize(text = nil)
    @text = text
  end

  def apply_auto_html(str)
    auto_html(str) do
      youtube
      redcloth
      link
    end
  end

  def apply_sanitize(str)
    Sanitize.clean(
      str,
      :elements => ['a', 'img', 'p', 'div', 'h2', 'h3', 'strong', 'em', 'ul', 'ol', 'li'],
      :attributes => {
        :all => ['src', 'alt', 'title', 'href']
      }
    )
  end

  def remove_tags(str)
    Sanitize.clean(str, :elements => [])
  end

  def render_show
    apply_sanitize(apply_auto_html(text)).html_safe
  end

  def render_index
    remove_tags(apply_auto_html(text)).to_s.truncate(180, :separator => ' ')
  end
end
