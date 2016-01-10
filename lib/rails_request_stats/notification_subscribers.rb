module RailsRequestStats
  class NotificationSubscribers
    SCHEMA_NAME = 'SCHEMA'.freeze
    CACHE_NAME = 'CACHE'.freeze

    class << self
      attr_accessor :query_count,
                    :cached_query_count,
                    :before_object_space,
                    :after_object_space
                    :requests
    end

    def self.reset_counts
      @query_count = 0
      @cached_query_count = 0
      @before_object_space = {}
      @after_object_space = {}
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
      GC.disable

      @before_object_space = ObjectSpace.count_objects(@before_object_space)
    end

    def self.handle_process_action_event(event)
      @after_object_space = ObjectSpace.count_objects(@after_object_space)

      GC.enable

      request_key = { action: event[:action], format: event[:format], method: event[:method], path: event[:path] }
      request_stats = @requests[request_key] || RequestStats.new(request_key)
      @requests[request_key] = request_stats.tap do |stats|
        stats.add_database_query_stats(@query_count, @cached_query_count)
        stats.add_object_space_stats(@before_object_space, @after_object_space)
        stats.add_runtime_stats(event[:view_runtime], event[:db_runtime])
      end

      print_report(request_stats)
    end

    def self.print_report(request_stats)
      Rails.logger.info { Report.new(request_stats).report_text }
    end
  end
end
