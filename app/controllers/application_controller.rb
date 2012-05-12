class ApplicationController < ActionController::Base
  helper_method :params_with_facet, :params_without_facet, :params_have_facet?

  protect_from_forgery

  layout 'public'

  def stub

  end

  protected
    def request_parameters
      Marshal.load(Marshal.dump(request.env['rack.request.query_hash'].symbolize_keys))
    end

    def params_facet_values(facet)
      [*params[:facets].try(:[], facet)]
    end

    def params_have_facet?(facet, value)
      params_facet_values(facet).include? value
    end

    def params_with_facet(facet, value)
      request_parameters.tap do | parameters |
        parameters[:facets] ||= {}
        parameters[:facets][facet] ||= []
        parameters[:facets][facet] << value
        parameters[:facets][facet].uniq!
      end
    end

    def params_without_facet(facet, value)
      request_parameters.tap do | parameters |
        parameters[:facets][facet].uniq!
        parameters[:facets][facet].delete(value)
      end
    end
end
