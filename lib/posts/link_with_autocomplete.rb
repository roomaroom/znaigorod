class Posts::LinkWithAutocomplete
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

  def afisha_hash(item)
    item = AfishaDecorator.new(item)

    label = item.title
    label << ", #{item.places.first.title}" if item.places.any?
    label << ", #{item.human_when}"

    {
      :value => "afisha_#{item.id}",
      :label => label
    }
  end

  def organization_hash(item)
    {
      :value => "organization_#{item.id}",
      :label => "#{item.title}, #{item.address}"
    }
  end

  def items_hash
    items.map { |item| send "#{item.class.name.underscore}_hash", item }
  end

  def json
    items_hash.to_json
  end
end

