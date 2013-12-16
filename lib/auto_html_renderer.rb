class AutoHtmlRenderer
  include AutoHtml

  attr_accessor :text

  def initialize(text = nil)
    @text = text
  end

  def render
    auto_html(text) do
      redcloth
      youtube
    end
  end
end
