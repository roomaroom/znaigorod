namespace :categories do
  desc 'Import categories from YML=(/path/to/yml)'
  task :import_from_yml => :environment do
    if ENV['YML']
      OrganizationImport::Categories.new(ENV['YML']).import
    else
      puts 'Usage rake organizations:import_categories YML=/path/to/yml'
    end
  end
end

namespace :organizations do
  desc 'Connect organizations with features'
  task :connect_with_features => :environment do
    Organization.all.each { |org| org.features += OrganizationImport::Features.new(org.feature).features }
  end

  desc 'Import organizations from 2gis CSV=(/path/to/csv) YML=(/path/to/yml)'
  task :import_from_csv => :environment do
    if ENV['CSV'] && ENV['YML']
      OrganizationImport::Categories.new(ENV['YML']).import

      Organization.all.each { |org| org.features += OrganizationImport::Features.new(org.feature).features }

      OrganizationImport::Organizations.new(ENV['CSV'], ENV['YML']).create_organizations

      OrganizationImport::OrganizationsCategoriesLinker.new.set_categories_for_organizations_with_suborganizations
    else
      puts 'Usage rake organizations:import_from_csv CSV=/path/to/csv YML=/path/to/yml'
    end
  end

  desc 'Find unmatched organization'
  task :find_unmatched => :environment do
    if ENV['CSV'] && ENV['YML']
      OrganizationImport::Categories.new(ENV['YML']).import

      OrganizationImport::Organizations.new(ENV['CSV'], ENV['YML']).find_unmatched
    else
      puts 'Usage rake organizations:find_unmatched CSV=/path/to/csv YML=/path/to/yml'
    end
  end

  desc 'Link organizations with categories'
  task :set_categories => :environment do
    OrganizationImport::OrganizationsCategoriesLinker.new.set_categories_for_organizations_with_suborganizations
  end
end
