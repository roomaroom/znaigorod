class Reviews::VerifiedClass
  def initialize(type: type)
    @type = type

    verify_type
  end

  def klass
    [:review, @type].join('_').classify.constantize
  end

  private

  def verify_type
    @type = ( Review.descendant_names_without_prefix & [@type] ).first

    raise 'Unknown Review type' unless @type
  end
end
