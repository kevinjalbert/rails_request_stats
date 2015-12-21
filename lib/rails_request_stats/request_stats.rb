module RailsRequestStats
  class RequestStats
    attr_reader :action,
                :format,
                :method,
                :path,

                :view_runtime_collection,
                :db_runtime_collection,
                :query_count_collection,
                :cached_query_count_collection,
                :cache_read_count_collection

    def initialize(key)
      @action = key[:action]
      @format = key[:format]
      @method = key[:method]
      @path = key[:path]

      @view_runtime_collection = []
      @db_runtime_collection = []
      @query_count_collection = []
      @cached_query_count_collection = []
      @cache_read_count_collection = []
    end

    def add_stats(view_runtime, db_runtime, query_count, cached_query_count, cache_read_count)
      @view_runtime_collection << view_runtime.to_f
      @db_runtime_collection << db_runtime.to_f
      @query_count_collection << query_count
      @cached_query_count_collection << cached_query_count
      @cache_read_count_collection << cache_read_count
    end
  end
end
