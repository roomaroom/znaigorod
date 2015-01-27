class AwayController < ActionController::Base
  def go
    path = request.fullpath.try :gsub, '/away?to=', ''

    link = LinkCounter.where(link: path.truncate(254)).first || LinkCounter.create(link_type: :external, name: path.truncate(254), link: path.truncate(254))
    link.increment! :count

    redirect_to path || root_path
  end
end
