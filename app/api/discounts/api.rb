# encoding: utf-8

#module Discounts
  #class API < Grape::API
    #prefix 'api'

    #format :json

    #rescue_from :all do |e|
      #Airbrake.notify_or_ignore(e)

      #Rack::Response.new([e.message], 500, { "Content-type" => "text/error" }).finish
    #end

    #helpers do
      #def affiliated_coupon
        #@affiliated_coupon ||= Prikupon::Importer.new(params[:data]).import
      #end

      #def url_of_created_coupon
        #Rails.application.routes.url_helpers.discount_url affiliated_coupon, :host => Settings['app.host']
      #end

      #def log_params
        #API.logger.debug "API (api/discounts) parameters: #{params.except('route_info').to_hash}"
      #end
    #end

    #resource :discounts do
      #params do
        #requires :data, :type => String
      #end

      #post do
        #log_params

        #url_of_created_coupon
      #end
    #end
  #end
#end
