class Question < Review
  extend Enumerize

  enumerize :categories,
    :in => [:children, :interesting, :auto, :accidents, :crash, :animal, :cookery, :eighteen_plus, :humor, :hi_tech,
            :leisure, :family, :lifehack, :economy, :complaints_book, :spirituality, :help,
            :sex, :creativity, :handmade, :boiling, :good_news, :health, :sport, :policy, :studies, :abiturient, :advertisement],
    :multiple => true,
    :predicates => true
end
