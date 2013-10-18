class FeedsPresenter

  attr_accessor :kind_filter

  def initialize(params)
    puts params['controller']
    @controller_name = params['controller']
    @activity_filter = FeedsActivityFilter.new(params['activity'])
    @kind_filter = FeedsKindFilter.new(params['kind'])
    @page = params['page']
    @page ||= 1
    @per_page = 10
    @account_id = params['id'] if params['id'].present?
    @account_id = params['account_id'] if params['account_id'].present?
    @searcher_params = {}
    searcher_params()
  end

  def private_feed?
    @controller_name == "my/accounts"
  end

  def public_feed?
    %w[accounts feeds].include?(@controller_name)
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

  def activity_links
    @activity_links ||= [].tap { |array|
      @activity_filter.available_kind_values.each do |kind|
        array << {
          title: I18n.t("feed_kinds.#{kind}"),
          klass: kind,
          parameters: {
            kind: kind,
          },
          selected: kind == @activity_filter.kind,
        }
      end
    }
  end

  def collection
    puts @searcher_params

    if public_feed?
      @feed ||= Kaminari.paginate_array(Feed.where(@searcher_params).order('created_at DESC')).page(@page).per(@per_page)
    end

    if private_feed?
      if @activity_filter.kind == "friends"
        @feed ||= Kaminari.paginate_array(Account.find(@account_id).friends_feeds(@searcher_params)).page(@page).per(@per_page)
      elsif @activity_filter.kind == "my"
        @feed ||= Kaminari.paginate_array(Feed.where(@searcher_params).order('created_at DESC')).page(@page).per(@per_page)
      end
    end

    @feed

  end

  def searcher_params
    @searcher_params[:feedable_type] = @kind_filter.kind.capitalize if @kind_filter.used?
    @searcher_params[:account_id] = @account_id if @account_id.present? && !@activity_filter.of_friends?
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

class FeedsActivityFilter

  attr_accessor :kind

  def initialize(kind)
    @kind = kind
  end

  def self.available_kind_values
    %w[my friends]
  end

  def available_kind_values
    self.class.available_kind_values
  end

  def kind
    available_kind_values.include?(@kind) ? @kind : 'my'
  end

  def of_friends?
    @kind == 'friends'
  end

  def used?
    kind != 'my'
  end

end
