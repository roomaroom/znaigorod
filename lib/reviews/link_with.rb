class Reviews::LinkWith
  attr_accessor :term

  def initialize(term)
    @term = term
  end

  def json
    items_hash.to_json
  end

  def self.available_types
    %w[afisha organization contest]
  end

  # private

  def items
    @items ||= begin
                 Sunspot.search(Afisha, Organization, Contest) {
                   keywords term, :fields => [:title, :title_ru, :title_translit]

                   with :state, :published
                 }.results
               end
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

  def contest_hash(item)
    {
      :value => "contest_#{item.id}",
      :label => "#{item.title} (Конкурс)"
    }
  end

  def items_hash
    items.map { |item| send "#{item.class.name.underscore}_hash", item }
  end
end

