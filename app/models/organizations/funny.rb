class Funny < Organization
  alias_attribute :funny_categories, :organization_categories

  def self.facets
    %w[organization_categories funny_categories payment feature offer]
  end

  add_sunspot_configuration
end

# == Schema Information
#
# Table name: organizations
#
#  id                      :integer         not null, primary key
#  title                   :text
#  organization_categories :text
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

