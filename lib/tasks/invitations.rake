# encoding: utf-8

namespace :invitations do

  desc 'Destroy all invitations with unactual afishas'
  task :destroy_irrelevant => :environment do
    Invitation.where(inviteable_type: "Afisha").without_invited.select {|i| !i.inviteable.actual? }.map(&:destroy)
  end
end
