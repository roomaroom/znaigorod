class Posts::MyCounters
  attr_accessor :account

  def initialize(account)
    @account = account
  end

  def counters
    {
      :all       => account.posts.count,
      :published => account.posts.by_state('published').count,
      :draft     => account.posts.by_state('draft').count
    }
  end
end
