# encoding: utf-8

module Discounts
  class API < Grape::API
    prefix 'api'

    format :json

    resource :discounts do
      params do
        requires :data
      end

      post do
        Prikupon::Importer.new(params[:data]).import
      end
    end
  end
end
