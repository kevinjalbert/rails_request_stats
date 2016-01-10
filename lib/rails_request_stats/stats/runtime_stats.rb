module RailsRequestStats
  module Stats
    class RuntimeStats
      attr_reader :view_runtime_collection,
                  :db_runtime_collection

      def initialize
        @view_runtime_collection = []
        @db_runtime_collection = []
      end

      def add_stats(view_runtime, db_runtime)
        @view_runtime_collection << view_runtime
        @db_runtime_collection << db_runtime
      end
    end
  end
end
