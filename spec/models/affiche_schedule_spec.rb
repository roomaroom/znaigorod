require 'spec_helper'

describe AfficheSchedule do
  describe 'should create showings for affiche' do
    let(:attributes) {
      Fabricate.attributes_for(:exhibition).merge({:affiche_schedule_attributes => Fabricate.attributes_for(:affiche_schedule)})
    }

    let(:exhibition) { Exhibition.create! attributes }

    it { exhibition.showings.count.should == 91 }
    it { exhibition.showings.first.place.should == 'place' }
    it { exhibition.showings.first.hall.should == 'hall' }
    it { exhibition.showings.first.starts_at.should == '2012-06-01 11:00'.to_datetime }
    it { exhibition.showings.first.ends_at.should == '2012-06-01 17:00'.to_datetime }
  end
end

# == Schema Information
#
# Table name: affiche_schedules
#
#  id         :integer         not null, primary key
#  affiche_id :integer
#  starts_on  :date
#  ends_on    :date
#  starts_at  :time
#  ends_at    :time
#  holidays   :string(255)
#  place      :string(255)
#  hall       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

