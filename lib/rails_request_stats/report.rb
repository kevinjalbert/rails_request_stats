module RailsRequestStats
  class Report
    FORMAT_FLAG = '%g'.freeze

    attr_reader :request_stats

    def initialize(request_stats)
      @request_stats = request_stats
    end

    def report_text
      avg_view_runtime = "AVG view_runtime: #{format_number(avg_stat(:view_runtime))}ms"
      avg_db_runtime = "AVG db_runtime: #{format_number(avg_stat(:db_runtime))}ms"
      query_count = "query_count: #{format_number(last_stat(:query_count))}"
      cached_query_count = "cached_query_count: #{format_number(last_stat(:cached_query_count))}"
      cache_read_count = "cache_read_count: #{format_number(last_stat(:cache_read_count))}"

      "[RailsRequestStats] (#{[avg_view_runtime, avg_db_runtime, query_count, cached_query_count, cache_read_count].join(' | ')})"
    end

    def exit_report_text
      controller_information = "[RailsRequestStats] #{@request_stats.action.upcase}:#{@request_stats.format} \"#{@request_stats.path}\""
      avg_view_runtime = "AVG view_runtime: #{format_number(avg_stat(:view_runtime))}ms"
      avg_db_runtime = "AVG db_runtime: #{format_number(avg_stat(:db_runtime))}ms"
      min_query_count = "MIN query_count: #{format_number(min_stat(:query_count))}"
      max_query_count = "MAX query_count: #{format_number(max_stat(:query_count))}"
      request_count = "from #{format_number(count_stat(:view_runtime))} requests"

      "#{controller_information} (#{[avg_view_runtime, avg_db_runtime, min_query_count, max_query_count].join(' | ')}) #{request_count}"
    end

    def min_stat(category)
      category_collection(category).min
    end

    def max_stat(category)
      category_collection(category).max
    end

    def total_stat(category)
      category_collection(category).reduce(:+)
    end

    def count_stat(category)
      category_collection(category).size
    end

    def last_stat(category)
      category_collection(category).last
    end

    def avg_stat(category)
      total_stat(category).to_f / count_stat(category)
    end

    private

    def format_number(number)
      format(FORMAT_FLAG, number)
    end

    def category_collection(category)
      collection_variable_name = "#{category}_collection"
      @request_stats.public_send(collection_variable_name) if @request_stats.respond_to?(collection_variable_name)
    end
  end
end
