class Crm::ActivitiesController < Crm::ApplicationController
  load_and_authorize_resource

  actions :all, except: :show

  belongs_to :organization, optional: true

  has_scope :page, default: 1

  def index
    @activities = HasSearcher.searcher(:activities, params[:search]).
      paginate(page: params[:page], per_page: 10).results
  end

  def create
    create! do |success, failure|
      #success.html { render file: 'crm/activities/list' and return }
      success.html { render partial: 'crm/activities/list', locals: { organization: @organization } and return }
    end
  end

  def update
    update! do |success, failure|
      #success.html { render file: 'crm/activities/list' and return }
      success.html { render partial: 'crm/activities/list', locals: { organization: @organization } and return }
    end
  end

  def destroy
    destroy! do |success, failure|
      #success.html { render file: 'crm/activities/list' and return }
      success.html { render partial: 'crm/activities/list', locals: { organization: @organization } and return }
    end
  end

  def meetings
    @activities = {}
    User.sales_managers.each do |u|
      @activities[u] = Activity.unscoped.where(user_id: u.id).with_state(:planned).with_meeting.where(activity_at: (Date.today - 1.day).beginning_of_day..(Date.today + 6.day).end_of_day).order(:activity_at).group_by(&:activity_date)
    end
  end

end
