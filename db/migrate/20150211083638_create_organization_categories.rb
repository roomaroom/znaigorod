class CreateOrganizationCategories < ActiveRecord::Migration
  def normalize_title(title)
    title.mb_chars.downcase.capitalize
  end

  def up
    create_table :organization_categories do |t|
      t.string :title
      t.string :ancestry

      t.timestamps
    end
    add_index :organization_categories, :ancestry

    create_table :organization_categories_organizations, :id => false do |t|
      t.references :organization_category
      t.references :organization
    end

    Organization.basic_suborganization_kinds.each do |kind|
      parent_title = normalize_title(I18n.t("organization.kind.#{kind}"))

      category = OrganizationCategory.create!(:title => parent_title)

      Values.instance.values.send(kind).categories.each do |v|
        title = normalize_title(v)

        next if parent_title == title

        category.children.create! :title => title
      end

      kind.classify.constantize.includes(:organization).each do |suborg|
        suborg.categories.each do |title|
          c = category.subtree.where(:title => normalize_title(title)).first

          suborg.organization.organization_categories << c
        end
      end
    end
  end

  def down
    drop_table :organizations_organization_categories
    drop_table :organization_categories
  end
end
