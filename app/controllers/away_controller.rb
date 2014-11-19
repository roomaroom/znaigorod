class AwayController < ActionController::Base
  def go
    path = request.fullpath.try :gsub, '/away?to=', ''

    link = LinkCounter.where(link: path).first || LinkCounter.create(link_type: :external, name: path, link: path)
    link.increment! :count

    redirect_to path || root_path
  end
end
