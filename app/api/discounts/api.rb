# encoding: utf-8

module Discounts
  class API < Grape::API
    prefix 'api'

    format :json

    helpers do
      def affiliated_coupon
        @affiliated_coupon ||= Prikupon::Importer.new(params[:data]).import
      end

      def url
        Rails.application.routes.url_helpers.discount_url affiliated_coupon, :host => Settings['app.host']
      end
    end

    resource :discounts do
      params do
        requires :data
      end

      post do
        { :url =>  url }
      end
    end
  end
end
