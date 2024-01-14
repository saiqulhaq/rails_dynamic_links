DynamicLinks.configure do |config|
  config.shortening_strategy = :md5 # or other strategy name, see StrategyFactory for available strategies
  config.enable_rest_api = true # or false. when false, the API requests will be rejected
  config.db_infra_strategy = :standard # or :sharding. if sharding is used, then xxx
  config.async_processing = true # or true. if true, the shortening process will be done asynchronously using ActiveJob
  config.cache_store_config = { type: :redis, redis_config: { host: 'redis', port: 6379 } }
  config.db_infra_strategy = :citus if ENV['CITUS_ENABLED'].to_s == 'true'
end
