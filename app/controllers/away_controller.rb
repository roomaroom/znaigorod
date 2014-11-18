class AwayController < ActionController::Base
  def go
    path = request.fullpath.try :gsub, '/away?to=', ''

    LinkCounter.delay.create(link_type: :external, name: path, link: path)

    redirect_to path || root_path
  end
end
