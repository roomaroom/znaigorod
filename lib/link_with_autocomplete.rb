class LinkWithAutocomplete
  attr_accessor :term

  def initialize(term)
    @term = term
  end

  def items
    return @items if @items

    @items = Sunspot.search(Afisha, Organization) {
      keywords term, :fields => [:title, :title_ru, :title_translit]

      with :state, :published
    }.results
  end

  def items_hash
    items.map do |item|
      {
        :value => "#{item.class.name.underscore}_#{item.id}",

        :label => item.title
      }
    end
  end

  def json
    items_hash.to_json
  end
end

