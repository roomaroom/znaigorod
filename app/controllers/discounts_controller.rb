class DiscountsController < ApplicationController
  inherit_resources

  actions :show

  def index

    respond_to do |format|
      format.html {
        @presenter = DiscountsPresenter.new(params.merge(:with_advertisement => true))
        @discounts = @presenter.decorated_collection

        render partial: 'discounts/discount_posters', layout: false and return if request.xhr?

      }

      format.rss {
        @presenter = DiscountsPresenter.new(:per_page => 15)
        render :layout => false
      }

      format.promotion do
        presenter = DiscountsPresenter.new(params.merge(:per_page => 5))

        render :partial => 'promotions/discounts', :locals => { :presenter => presenter }
      end
    end
  end

  def show
    show! do |format|
      format.html do
        @discount = DiscountDecorator.new(@discount)
        @presenter = DiscountsPresenter.new(params.merge(:kind => @discount.kind.map(&:value).first, :type => @discount.model.type_for_solr))
        @discount.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
        @members = @discount.members.page(1).per(3)
      end

      format.promotion do
        discount = DiscountDecorator.new(@discount)

        render :partial => 'promotions/discount', :locals => { :decorated_discount => discount }
      end
    end
  end
end
