module RailsRequestStats
  module Stats
    class CacheStats
      attr_reader :cache_read_count_collection
      attr_reader :cache_hit_count_collection

      def initialize
        @cache_read_count_collection = []
        @cache_hit_count_collection = []
      end

      def add_stats(cache_read_count, cache_hit_count)
        @cache_read_count_collection << cache_read_count
        @cache_hit_count_collection << cache_hit_count
      end
    end
  end
end
