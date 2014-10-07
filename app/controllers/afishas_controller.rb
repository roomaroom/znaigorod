# encoding: utf-8

class AfishasController < ApplicationController
  respond_to :html, :rss, :promotion

  def index

    respond_to do |format|
      format.html {
        cookie = cookies['_znaigorod_afisha_list_settings'].to_s
        settings_from_cookie = {}
        settings_from_cookie = Rack::Utils.parse_nested_query(cookie) if cookie.present?

        @presenter = AfishaPresenter.new(settings_from_cookie.merge(params))
        if request.xhr?
          if params[:page]
            render partial: @presenter.partial, :locals => { :afishas => @presenter.decorated_collection, :presenter => @presenter }, :layout => false and return
          end
        end
      }

      format.rss {
        @presenter = AfishaPresenter.new({})
        render :layout => false
      }

      format.promotion {
        presenter = AfishaPresenter.new(:per_page => 3)

        render :partial => 'promotions/afishas', :locals => { :presenter => presenter }
      }
    end
  end

  def show
    @afisha = AfishaDecorator.new Afisha.published.find(params[:id])
    @kind_afishas = @afisha.kind_searcher(@afisha.kind.first, @afisha.id)

    respond_to do |format|
      format.html {
        @afisha.delay(:queue => 'critical').create_page_visit(request.session_options[:id], request.user_agent, current_user)
        @presenter = AfishaPresenter.new(params.merge(:categories => [@afisha.kind.first]))
        @visits = @afisha.visits.page(1)
        @bet = @afisha.bets.build
        @certificates = @afisha.organization ? DiscountsPresenter.new(:organization_id => @afisha.organization.id, :type => 'certificate').decorated_collection : []
        @reviews = ReviewDecorator.decorate(@afisha.reviews.published.ordered)
      }

      format.promotion do
        render :partial => 'promotions/afisha', :locals => { :decorated_afisha => @afisha }
      end
    end
  end

  def single_afisha
  end

  def afisha_collection
    searcher = HasSearcher.searcher(:afishas, :q => params[:q], :state => 'published')
      .paginate(:page => params[:page], :per_page => 12)

    afishas = {}

    searcher.results.each do |afisha|
      hash_info = {}.tap{ |info|
        info['image'] = afisha.image_url
        info['title'] = afisha.title
        info['url'] = afisha_show_url(afisha)
      }
      afishas[afisha.id] = hash_info
    end

    render json: afishas.to_json, :callback => params['callback']
  end
end
