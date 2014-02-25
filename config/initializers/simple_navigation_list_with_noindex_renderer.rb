SimpleNavigation::ItemContainer.class_eval <<-EVAL
  attr_accessor :noindex
EVAL

module SimpleNavigation
  module Renderer
    class ListWithNoindex < List
      include ActionView::Helpers::OutputSafetyHelper

      def render(item_container)
        item_container.noindex ?
          raw("<!--noindex-->#{super(item_container)}<!--/noindex-->") :
          super(item_container)
      end
    end

    SimpleNavigation.register_renderer :list_with_noindex => ListWithNoindex
  end
end
