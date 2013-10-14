# encoding: utf-8

class Advertisement
  include ActiveAttr::MassAssignment
  attr_accessor :list, :page, :places

  def initialize(args)
    super(args)
    @configuration = (YAML.load_file(Rails.root.join('config', 'advertisement.yml'))[@list.to_s] || {})['places'] || []
    @configuration = @configuration.to_a
    initialize_places
  end

  def initialize_places
    @places ||= [].tap do |array|
      @configuration.each do |place_config|
        place_in_list, place_config = place_config[0], place_config[1]
        from, to = Time.zone.parse(place_config['from']), Time.zone.parse(place_config['to'])
        next if from >= Time.zone.now || to <= Time.zone.now
        share_config = {
          :list => @list,
          :replaced_count => place_config['replaced_count'],
          :page => place_in_list.split('.').first.to_i,
          :position => place_in_list.split('.').second.to_i
        }
        array << case place_config['content_type']
        when 'afisha'
          afisha_adv = AfishaAdvertisementPlace.new(share_config.merge(slug: place_config['afisha_slug']))
          afisha_adv.afisha ? afisha_adv : nil
        when 'webcam'
          WebcamAdvertisementPlace.new(share_config)
        else
          nil
        end
        array.compact!
      end
    end
  end

  def places_at(page)
    @places_at_page ||= places.select {|pl| pl.page == page }
  end

  def afishas
    @afishas ||= places.select {|pl| pl.is_a?(AfishaAdvertisementPlace) }.map(&:afisha)
  end

  class AdvertisementPlace
    include ActiveAttr::MassAssignment
    attr_accessor :page, :position, :replaced_count, :list
  end

  class AfishaAdvertisementPlace < AdvertisementPlace
    attr_accessor :slug, :afisha
    delegate :title, :human_when, :human_price, :places, :poster_url,
             :distribution_ends_on?, :showings, :tickets, :truncated_title_link,
             :has_tickets_for_sale?, :poster_with_link, :premiere?,
             :visits, :invitations, :comments, :likes_count, :page_visits,
             :age_min, :afisha_place, to: :decorated_afisha

    def initialize(args)
      super(args)
      @afisha = Afisha.published.find_by_slug(slug)
    end

    def partial
      "advertisements/#{list}_afisha_#{replaced_count}"
    end

    def decorated_afisha
      @decorated_afisha ||= AfishaDecorator.new(afisha)
    end

  end

  class WebcamAdvertisementPlace < AdvertisementPlace
    def partial
      "advertisements/#{list}_webcam_#{replaced_count}"
    end
  end
end
