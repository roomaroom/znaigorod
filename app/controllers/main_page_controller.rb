class MainPageController < ApplicationController

  def show
    @afisha_list       = MainPagePoster.where('afisha_id is not null').ordered.actual.map { |afisha| AfishaDecorator.new Afisha.find(afisha.afisha_id) }

    other_afishas_list = AfishaPresenter.new(:per_page => 6 - @afisha_list.count, :without_advertisement => true, :order_by => 'creation', main_page: true).decorated_collection
    @afisha_list += other_afishas_list
    @afisha_filter     = AfishaPresenter.new(:has_tickets => false)

    @organizations     = OrganizationsCatalogPresenter.new(:per_page => 6)

    @certificates      = DiscountsPresenter.new(:type => 'certificate', :per_page => 3, :order_by => 'random').decorated_collection
    @offered_discount  = DiscountsPresenter.new(:type => 'offered_discount', :per_page => 2, :order_by => 'random').decorated_collection
    @discounts         = [@certificates, @offered_discount].flatten.shuffle
    advertisement = Advertisement.new(list: 'main_page_discounts')
    advertisement.places_at(1).compact.each do |adv|
      @discounts[adv.position] = adv
    end

    @discount_filter   = DiscountsPresenter.new(params)
    @accounts          = AccountsPresenter.new(:per_page => 6, :acts_as => ['inviter', 'invited'], :with_avatar => true)
    @photogalleries    = Photogallery.order('id desc').limit(3)
    @photo_decorator   = PhotogalleryDecorator.decorate(@photogalleries)
    @webcams           = Webcam.our.published.shuffle.take(5)

    @decorated_reviews = MainPageReview.used.map { |m| ReviewDecorator.new m.review }
  end

end
