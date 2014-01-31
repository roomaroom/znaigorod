Sidekiq.configure_server do |config|
  config.redis = { :url => Settings[:redis][:url], :namespace => 'znaigorod' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => Settings[:redis][:url], :namespace => 'znaigorod' }
end

# NOTE: Братюни, следующий код можно безсыкотно удалить, если с ним возникнут проблемы
#       Это так, чисто попробовать
if Rails.env.development? && Settings['redis.fake']
  module Sidekiq
    require 'mock_redis'

    class RedisConnection
      class << self
        def build_client(url, namespace, driver, network_timeout)
          MockRedis.new
        end
      end
    end
  end
end
