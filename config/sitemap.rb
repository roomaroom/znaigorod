# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = Rails.env.production? ? "http://znaigorod.ru" : "http://localhost:3000"
SitemapGenerator::Sitemap.sitemaps_path = Rails.env.production? ? File.expand_path('../../../../shared/sitemaps/', __FILE__) : ''
SitemapGenerator::Sitemap.create_index = false

SitemapGenerator::Sitemap.create do

  # Списки афиши
  ([''] + ShowingsPresenter.new({}).categories_filter.available).each do |category|
    (%w( today week weekend) + ['']).each do |period|
      params = {}
      params.merge!('categories[]' => category) unless category.blank?
      params.merge!('period' => period) unless period.blank?
      add affiches_path(params), :changefreq => 'daily', :priority => 0.7, :lastmod => Affiche.unscoped.last.updated_at
    end
  end
  # Фотогалереи
  add photogalleries_path('all'),               :changefreq => 'daily', :priority => 0.5, :lastmod => Affiche.unscoped.last.updated_at

  # Заведения города Томска
  add organizations_path,                       :changefreq => 'daily', :priority => 0.5, :lastmod => Organization.unscoped.last.updated_at

  # Заведения общественного питания в Томске
  ([''] + MealsPresenter.new({}).categories_filter.available).each do |category|
      params = {}
      params.merge!('categories[]' => category) unless category.blank?
    add meals_path(params),              :changefreq => 'daily', :priority => 0.7, :lastmod => Meal.unscoped.last.updated_at
  end

  # Развлекательные заведения в Томске
  ([''] + EntertainmentsPresenter.new({}).categories_filter.available).each do |category|
      params = {}
      params.merge!('categories[]' => category) unless category.blank?
    add entertainments_path(params),              :changefreq => 'daily', :priority => 0.7, :lastmod => Entertainment.unscoped.last.updated_at
  end

  # Сауны
  add saunas_path,              :changefreq => 'daily', :priority => 0.7, :lastmod => Sauna.unscoped.last.updated_at

  # Культурные заведения в Томске
  ([''] + CulturesPresenter.new({}).categories_filter.available).each do |category|
      params = {}
      params.merge!('categories[]' => category) unless category.blank?
    add cultures_path(params),              :changefreq => 'daily', :priority => 0.7, :lastmod => Culture.unscoped.last.updated_at
  end

  # Спортивные заведения
  ([''] + SportsPresenter.new({}).categories_filter.available).each do |category|
      params = {}
      params.merge!('categories[]' => category) unless category.blank?
    add sports_path(params),              :changefreq => 'daily', :priority => 0.7, :lastmod => Sport.unscoped.last.updated_at
  end

  # Творчество и развитие
  ([''] + CreationsPresenter.new({}).categories_filter.available).each do |category|
      params = {}
      params.merge!('categories[]' => category) unless category.blank?
    add creations_path(params),              :changefreq => 'daily', :priority => 0.7, :lastmod => Creation.unscoped.last.updated_at
  end

  # Публикации
  add posts_path,              :changefreq => 'weekly', :priority => 0.7, :lastmod => Post.unscoped.last.updated_at

  # Размещение информации
  add cooperation_path,        :changefreq => 'weekly', :priority => 0.7, :lastmod => DateTime.now - 7.days

  # Мероприятия
  max_popularity = Affiche.all.map(&:popularity).max
  Affiche.find_each do |affiche|
    add send("#{affiche.class.name.downcase}_path", affiche),
      :changefreq => 'weekly',
      :priority => affiche.popularity/max_popularity,
      :lastmod => affiche.updated_at #,
      #:images => [{ :loc => affiche.poster_url, :title => affiche.title }]
  end

  max_rating = Organization.all.map(&:rating).max
  Organization.find_each do |organization|
    if organization.subdomain.blank?
      add organization_path(organization),
        :changefreq => 'weekly',
        :priority => organization.rating/max_rating,
        :lastmod => organization.updated_at #,
      #:images => [{ :loc => organization.logotype_url, :title => organization.title }]
    else
      add '',
        :changefreq => 'weekly',
        :priority => organization.rating/max_rating,
        :lastmod => organization.updated_at,
        :host => "http://#{organization.subdomain}.znaigorod.ru"
    end
  end

  Post.find_each do |post|
    add post_path(post),
      :changefreq => 'monthly',
      :priority => 0.6,
      :lastmod => post.updated_at
  end
end
