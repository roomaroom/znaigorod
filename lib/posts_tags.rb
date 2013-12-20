class PostsTags
  attr_accessor :term

  def initialize(term = nil)
    @term = term
  end

  def tags
    term.present? ? tags_with_term : all_tags
  end

  private

  def all_tags
    @all_tags ||= Post.pluck(:tag).map { |tag| tag || '' }.flat_map { |tag| tag.split(',').map(&:squish) }.uniq.delete_if(&:blank?)
  end

  def tags_with_term
    all_tags.select { |tag| tag.match(/#{term}/i) }
  end
end
