module RailsRequestStats
  class RequestStats
    attr_reader :action,
                :format,
                :method,
                :path,

                :database_query_stats,
                :object_space_stats,
                :runtime_stats,
                :cache_stats

    def initialize(key)
      @action = key[:action]
      @format = key[:format]
      @method = key[:method]
      @path = key[:path]

      @database_query_stats = Stats::DatabaseQueryStats.new
      @object_space_stats = Stats::ObjectSpaceStats.new
      @runtime_stats = Stats::RuntimeStats.new
      @cache_stats = Stats::CacheStats.new
    end

    def add_database_query_stats(query_count, cached_query_count)
      @database_query_stats.add_stats(query_count, cached_query_count)
    end

    def add_object_space_stats(before_object_space, after_object_space)
      @object_space_stats.add_stats(before_object_space, after_object_space)
    end

    def add_runtime_stats(view_runtime, db_runtime)
      @runtime_stats.add_stats(view_runtime, db_runtime)
    end

    def add_cache_stats(cache_read_count, cache_hit_count)
      @cache_stats.add_stats(cache_read_count, cache_hit_count)
    end
  end
end
