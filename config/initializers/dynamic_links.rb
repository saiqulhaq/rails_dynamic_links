DynamicLinks.configure do |config|
  config.shortening_strategy = :md5  # Default strategy
  # config.redis_config = { host: 'localhost', port: 6379 }  # Redis configuration
  # config.redis_pool_size = 10  # Redis connection pool size
  # config.redis_pool_timeout = 3  # Redis connection pool timeout in seconds
  config.enable_rest_api = true  # Enable or disable REST API feature
end

