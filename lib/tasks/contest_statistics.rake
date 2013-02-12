require 'vkontakte_api'

def vk_client
  VkontakteApi.log_errors = false
  VkontakteApi.log_requests = false
  @vk_client ||= VkontakteApi::Client.new
end

def type
  'sitepage'
end

def owner_id
  '3136085'
end

def likes_for(page_url)
  begin
    return vk_client.likes.get_list(type: type, owner_id: owner_id, page_url: page_url)['count']
  rescue VkontakteApi::Error => e
    return 0
  end
end

desc "Sync statistics for contest works"
task :contest_statistics, [:slug] => :environment do |t, args|

  contest = Contest.find_by_slug! args.slug

  raise "can't find contest with slug '#{args.slug}'" unless contest
  bar = ProgressBar.new(contest.works.count)
  puts "Update works statistics for '#{contest.title}'"
  contest.works.each do |work|
    work_slug = work.slug
    work_slug = work.id if work.slug.empty?
    url = "http://znaigorod.ru/contests/#{contest.slug}/works/#{work_slug}"
    work.update_attribute :vk_likes, likes_for(url)
    bar.increment!
  end

end
