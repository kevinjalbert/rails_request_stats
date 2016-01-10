module RailsRequestStats
  module Stats
    class DatabaseQueryStats
      attr_reader :query_count_collection,
                  :cached_query_count_collection

      def initialize
        @query_count_collection = []
        @cached_query_count_collection = []
      end

      def add_stats(query_count, cached_query_count)
        @query_count_collection << query_count
        @cached_query_count_collection << cached_query_count
      end
    end
  end
end
