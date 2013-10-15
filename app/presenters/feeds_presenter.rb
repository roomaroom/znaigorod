class FeedsPresenter

  attr_accessor :kind_filter

  def initialize(params)
    @kind_filter = FeedsKindFilter.new(params['kind'])
    @page = params['page']
    @page ||= 1
    @per_page = 10
  end

  def kinds_links
    @kinds_links ||= [].tap { |array|
      @kind_filter.available_kind_values.each do |kind|
        array << {
          title: I18n.t("feed_kinds.#{kind}"),
          klass: kind,
          parameters: {
            kind: kind,
          },
          selected: kind == @kind_filter.kind,
        }
      end
    }
  end

  def collection
    @feeds = end_of_association_chain.where(:feedable_type => params[:kind]).page(@page).per(@per_page)
  end

end

class FeedsKindFilter

  attr_accessor :kind

  def initialize(kind)
    @kind = kind
  end

  def self.available_kind_values
    %w[all comment vote visit afisha invitation friend]
  end

  def available_kind_values
    self.class.available_kind_values
  end

  def kind
    available_kind_values.include?(@kind) ? @kind : 'all'
  end

  def used?
    kind != 'all'
  end

end
