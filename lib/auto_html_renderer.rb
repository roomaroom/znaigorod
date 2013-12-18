class AutoHtmlRenderer
  include AutoHtml

  attr_accessor :text

  def initialize(text = nil)
    @text = text
  end

  def render
    auto_html(text) do
      youtube
      redcloth
      simple_format
    end
  end
end
