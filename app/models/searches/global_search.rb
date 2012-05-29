class GlobalSearch < Search
  attr_accessible :keywords

  column :keywords, :text

  def results
    search.hits
    search.results
  end

  protected
    def klass
      [Affiche, Organization]
    end
end
