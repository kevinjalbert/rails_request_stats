module RailsRequestStats
  class NotificationSubscribers
    SCHEMA_NAME = 'SCHEMA'.freeze
    CACHE_NAME = 'CACHE'.freeze

    attr_reader :query_count,
                :cached_query_count,
                :before_action_object_count,
                :generated_object_count,
                :requests

    def self.reset_counts
      @query_count = 0
      @cached_query_count = 0
      @before_action_object_count = 0
      @generated_object_count = 0
    end
    reset_counts

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

    ActiveSupport::Notifications.subscribe('start_processing.action_controller') do |*args|
      handle_start_processing_event(args.extract_options!)
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

    def self.handle_start_processing_event(event)
      reset_counts

      GC.start
      @before_action_object_count = total_object_count
    end

    def self.handle_process_action_event(event)
      @generated_object_count = total_object_count - @before_action_object_count

      request_key = { action: event[:action], format: event[:format], method: event[:method], path: event[:path] }

      request_stats = @requests[request_key] || RequestStats.new(request_key)
      request_stats.add_stats(event[:view_runtime], event[:db_runtime], @query_count, @cached_query_count, @generated_object_count)

      @requests[request_key] = request_stats

      Rails.logger.info { Report.new(request_stats).report_text }
    end

    class << self
      private

      def total_object_count
        ObjectSpace.count_objects.select { |k, v| k.to_s.start_with?('T_') }.values.reduce(:+)
      end
    end
  end
end
