class OrganizationCategory < ActiveRecord::Base
  alias_attribute :to_s, :title
  attr_accessible :title

  default_scope order('title')

  validates :title, presence: true, uniqueness: { scope: :ancestry }

  has_ancestry

  def downcased_title
    title.mb_chars.downcase.to_s
  end

  def available_kinds
    I18n.t('organization.kind').invert.inject({}) { |h, (k, v)| h[k.mb_chars.downcase.to_s] = v.to_s; h }
  end

  def kind
    parent ? available_kinds[parent.downcased_title] : available_kinds[downcased_title]
  end

  def organizations_count
    facet_row = Organization.search { facet :organization_category, :only => downcased_title }.facet(:organization_category).rows.first

    facet_row ? facet_row.count : 0
  end
end
