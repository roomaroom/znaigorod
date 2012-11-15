# encoding: utf-8

class EntertainmentDecorator < SuborganizationDecorator
  decorates :entertainment

  def cuisines
    []
  end

  def info
    "развлекуха"
  end
end
