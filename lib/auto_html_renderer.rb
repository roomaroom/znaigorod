class AutoHtmlRenderer
  include AutoHtml

  attr_accessor :text

  def initialize(text = nil)
    @text = text
  end

  def apply_auto_html(str, options = {})
    auto_html(str) do
      youtube options[:youtube] || { :width => 700 }
      redcloth
    end
  end

  def apply_sanitize(str)
    Sanitize.clean(
      str,
      :elements => ['a', 'img', 'p', 'div', 'h2', 'h3', 'strong', 'em', 'ul', 'ol', 'li', 'iframe'],
      :attributes => {
        :all => ['src', 'alt', 'title', 'href', 'width', 'height', 'frameborder', 'allowfullscreen']
      }
    )
  end

  def remove_tags(str)
    Sanitize.clean(str, :elements => [])
  end

  def render_show(options = {})
    apply_sanitize(apply_auto_html(text, options)).html_safe
  end

  def render_index(length=180)
    remove_tags(apply_auto_html(text)).to_s.truncate(length, :separator => ' ')
  end
end
