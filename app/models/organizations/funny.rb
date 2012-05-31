class Funny < Organization
  def self.or_facets
    %w[categories]
  end

  def self.facets
    %w[categories payment feature offer]
  end

  add_sunspot_configuration
end

# == Schema Information
#
# Table name: organizations
#
#  id                      :integer         not null, primary key
#  title                   :text
#  categories :text
#  payment                 :text
#  cuisine                 :text
#  feature                 :text
#  site                    :text
#  email                   :text
#  description             :text
#  created_at              :datetime        not null
#  updated_at              :datetime        not null
#  phone                   :text
#  offer                   :text
#  type                    :string(255)
#  vfs_path                :string(255)
#

