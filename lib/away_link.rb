class AwayLink
  def self.to(to)
    "#{Settings['app.url']}/away?to=#{to}"
  end
end
