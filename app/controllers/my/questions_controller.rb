class My::QuestionsController < My::ApplicationController
  load_and_authorize_resource

  actions :all
end
