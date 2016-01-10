module RailsRequestStats
  class Report
    FORMAT_FLAG = '%g'.freeze

    attr_reader :request_stats

    def initialize(request_stats)
      @request_stats = request_stats
    end

    def report_text
      avg_view_runtime = "AVG view_runtime: #{format_number(avg(runtime_stats.view_runtime_collection))}ms"
      avg_db_runtime = "AVG db_runtime: #{format_number(avg(runtime_stats.db_runtime_collection))}ms"
      avg_generated_object_count = "AVG generated_object_count: #{format_number(avg(object_space_stats.generated_object_count_collection))}"
      query_count = "query_count: #{format_number(database_query_stats.query_count_collection.last)}"
      cached_query_count = "cached_query_count: #{format_number(database_query_stats.cached_query_count_collection.last)}"

      "[RailsRequestStats] (#{[avg_view_runtime, avg_db_runtime, avg_generated_object_count, query_count, cached_query_count].join(' | ')})"
    end

    def exit_report_text
      controller_information = "[RailsRequestStats] #{@request_stats.action.upcase}:#{@request_stats.format} \"#{@request_stats.path}\""
      avg_view_runtime = "AVG view_runtime: #{format_number(avg(runtime_stats.view_runtime_collection))}ms"
      avg_db_runtime = "AVG db_runtime: #{format_number(avg(runtime_stats.db_runtime_collection))}ms"
      avg_generated_object_count = "AVG generated_object_count: #{format_number(avg(object_space_stats.generated_object_count_collection))}"
      min_query_count = "MIN query_count: #{format_number(database_query_stats.query_count_collection.min)}"
      max_query_count = "MAX query_count: #{format_number(database_query_stats.query_count_collection.max)}"
      request_count = "from #{format_number(runtime_stats.view_runtime_collection.size)} requests"

      "#{controller_information} (#{[avg_view_runtime, avg_db_runtime, avg_generated_object_count, min_query_count, max_query_count].join(' | ')}) #{request_count}"
    end

    def total(collection)
      collection.reduce(:+)
    end

    def avg(collection)
      total(collection).to_f / collection.size
    end

    private

    def format_number(number)
      format(FORMAT_FLAG, number || 0)
    end

    def database_query_stats
      @database_query_stats ||= @request_stats.database_query_stats
    end

    def object_space_stats
      @object_space_stats ||= @request_stats.object_space_stats
    end

    def runtime_stats
      @runtime_stats ||= @request_stats.runtime_stats
    end
  end
end
