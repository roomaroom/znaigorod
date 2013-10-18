# encoding: utf-8

class My::DiscountsController < My::ApplicationController

  load_and_authorize_resource

  actions :new, :create, :edit, :update, :destroy
end
