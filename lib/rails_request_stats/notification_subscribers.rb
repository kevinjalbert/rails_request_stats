module RailsRequestStats
  class NotificationSubscribers
    SCHEMA_NAME = 'SCHEMA'.freeze
    CACHE_NAME = 'CACHE'.freeze

    attr_reader :query_count,
                :cached_query_count,
                :requests

    def self.reset_query_counts
      @query_count = 0
      @cached_query_count = 0
    end
    reset_query_counts

    def self.reset_requests
      @requests = {}
    end
    reset_requests

    at_exit do
      at_exit_handler
    end

    ActiveSupport::Notifications.subscribe('sql.active_record') do |*args|
      handle_sql_event(args.extract_options!)
    end

    ActiveSupport::Notifications.subscribe('process_action.action_controller') do |*args|
      handle_process_action_event(args.extract_options!)
    end

    def self.at_exit_handler
      @requests.each_value do |request_stats|
        Rails.logger.info { Report.new(request_stats).exit_report_text }
      end
    end

    def self.handle_sql_event(event)
      return if event[:name] == SCHEMA_NAME

      @cached_query_count += 1 if event[:name] == CACHE_NAME
      @query_count += 1
    end

    def self.handle_process_action_event(event)
      request_key = { action: event[:action], format: event[:format], method: event[:method], path: event[:path] }

      request_stats = @requests[request_key] || RequestStats.new(request_key)
      request_stats.add_stats(event[:view_runtime], event[:db_runtime], @query_count, @cached_query_count)

      @requests[request_key] = request_stats
      reset_query_counts

      Rails.logger.info { Report.new(request_stats).report_text }
    end
  end
end
