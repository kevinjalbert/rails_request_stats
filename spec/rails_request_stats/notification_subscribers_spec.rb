require 'spec_helper'

describe RailsRequestStats::NotificationSubscribers do
  before(:each) do
    described_class.reset_counts
    described_class.reset_requests
  end

  describe '.at_exit_handler' do
    it 'calls existing Report#exit_report_text' do
      requests = { '/users' => RailsRequestStats::RequestStats.new({}) }
      described_class.instance_variable_set('@requests', requests)

      expect_any_instance_of(RailsRequestStats::Report).to receive(:exit_report_text).once

      described_class.at_exit_handler
    end
  end

  describe 'sql.active_record subscription' do
    it 'receives event' do
      data = {
        sql: 'SELECT * from "users"',
        name: 'User Load',
        connection_id: 70301500045300,
        statement_name: nil,
        binds: []
      }

      expect(described_class).to receive(:handle_sql_event).with(data)
      ActiveSupport::Notifications.instrument('sql.active_record', data)
    end
  end

  describe 'start_processing.action_controller subscription' do
    it 'receives event' do
      data = {
        controller: 'UsersController',
        action: 'index',
        params: { 'controller' => 'users', 'action' => 'index' },
        format: :html,
        method: 'GET',
        path: '/users'
      }

      expect(described_class).to receive(:handle_start_processing_event).with(data)
      ActiveSupport::Notifications.instrument('start_processing.action_controller', data)
    end
  end

  describe 'process_action.action_controller subscription' do
    it 'receives event' do
      data = {
        controller: 'UsersController',
        action: 'index',
        params: { 'controller' => 'users', 'action' => 'index' },
        format: :html,
        method: 'GET',
        path: '/users',
        status: 200,
        view_runtime: 175.11533110229672,
        db_runtime: 15.542000000000002
      }

      expect(described_class).to receive(:handle_process_action_event).with(data)
      ActiveSupport::Notifications.instrument('process_action.action_controller', data)
    end
  end

  describe '.handle_sql_event' do
    it 'processes normal sql event' do
      event = {
        sql: 'SELECT * from "users"',
        name: 'User Load',
        connection_id: 70301500045300,
        statement_name: nil,
        binds: []
      }

      described_class.handle_sql_event(event)

      expect(described_class.instance_variable_get('@query_count')).to eq(1)
      expect(described_class.instance_variable_get('@cached_query_count')).to eq(0)
    end

    it 'processes schema sql event' do
      event = {
        sql: 'SET time zone "UTC"',
        name: described_class::SCHEMA_NAME,
        connection_id: 70301500045300,
        statement_name: nil,
        binds: []
      }

      described_class.handle_sql_event(event)

      expect(described_class.instance_variable_get('@query_count')).to eq(0)
      expect(described_class.instance_variable_get('@cached_query_count')).to eq(0)
    end

    it 'processes cache sql event' do
      event = {
        sql: 'SELECT * from "users"',
        name: described_class::CACHE_NAME,
        connection_id: 70301500045300,
        statement_name: nil,
        binds: []
      }

      described_class.handle_sql_event(event)

      expect(described_class.instance_variable_get('@query_count')).to eq(1)
      expect(described_class.instance_variable_get('@cached_query_count')).to eq(1)
    end
  end

  describe '.handle_start_processing_event' do
    it 'processes start controller action event' do
      action = 'index'
      format = :html
      method = 'GET'
      path = '/users'

      event = {
        controller: 'UsersController',
        action: action,
        params: { 'controller' => 'users', 'action' => action },
        format: format,
        method: method,
        path: path
      }

      expect(described_class).to receive(:reset_counts).once
      expect(GC).to receive(:start).once

      described_class.handle_start_processing_event(event)

      expect(described_class.instance_variable_get('@before_object_space').keys).not_to eq(0)
    end
  end

  describe '.handle_cache_read_event' do
    context 'cache hit' do
      it 'processes cache read event' do
        event = {
          key: 'awesome/event_serializer/1da77373824117ede4eb3359f1a56467/attributes',
          super_operation: :fetch,
          hit: true
        }

        described_class.handle_cache_read_event(event)

        expect(described_class.instance_variable_get('@cache_read_count')).to eq(1)
        expect(described_class.instance_variable_get('@cache_hit_count')).to eq(1)
      end
    end

    context 'no cache hit' do
      it 'processes cache read event' do
        event = {
          key: 'awesome/event_serializer/1da77373824117ede4eb3359f1a56467/attributes',
          super_operation: :fetch
        }

        described_class.handle_cache_read_event(event)

        expect(described_class.instance_variable_get('@cache_read_count')).to eq(1)
        expect(described_class.instance_variable_get('@cache_hit_count')).to eq(0)
      end
    end
  end

  describe '.handle_cache_fetch_hit_event' do
    context 'cache fetch hit' do
      it 'processes cache fetch hit event' do
        event = { key: 'awesome/event_serializer/1da77373824117ede4eb3359f1a56467/attributes' }

        described_class.handle_cache_fetch_hit_event(event)

        expect(described_class.instance_variable_get('@cache_hit_count')).to eq(1)
      end
    end
  end

  describe '.handle_process_action_event' do
    it 'processes controller action event' do
      action = 'index'
      format = :html
      method = 'GET'
      path = '/users'
      view_runtime = 175.11533110229672
      db_runtime = 15.542000000000002
      query_count = 0
      cached_query_count = 0
      before_object_space = {
        TOTAL: 172415,
        FREE: 54053,
        T_OBJECT: 10157,
        T_CLASS: 889,
        T_MODULE: 31,
        T_FLOAT: 4,
        T_STRING: 77219,
        T_REGEXP: 190,
        T_ARRAY: 23234,
        T_HASH: 2014,
        T_STRUCT: 2,
        T_BIGNUM: 2,
        T_FILE: 10,
        T_DATA: 1937,
        T_MATCH: 107,
        T_COMPLEX: 1,
        T_NODE: 2528,
        T_ICLASS: 37
      }
      after_object_space = {
        TOTAL: 172415,
        FREE: 53053,
        T_OBJECT: 11157,
        T_CLASS: 889,
        T_MODULE: 31,
        T_FLOAT: 4,
        T_STRING: 77219,
        T_REGEXP: 190,
        T_ARRAY: 23234,
        T_HASH: 2014,
        T_STRUCT: 2,
        T_BIGNUM: 2,
        T_FILE: 10,
        T_DATA: 1937,
        T_MATCH: 107,
        T_COMPLEX: 1,
        T_NODE: 2528,
        T_ICLASS: 37
      }

      event = {
        controller: 'UsersController',
        action: action,
        params: { 'controller' => 'users', 'action' => action },
        format: format,
        method: method,
        path: path,
        status: 200,
        view_runtime: view_runtime,
        db_runtime: db_runtime
      }

      described_class.instance_variable_set('@before_object_space', before_object_space)
      described_class.instance_variable_set('@after_object_space', after_object_space)

      expect_any_instance_of(RailsRequestStats::RequestStats).to receive(:add_database_query_stats).with(query_count, cached_query_count).once
      expect_any_instance_of(RailsRequestStats::RequestStats).to receive(:add_object_space_stats).with(before_object_space, after_object_space).once
      expect_any_instance_of(RailsRequestStats::RequestStats).to receive(:add_runtime_stats).with(view_runtime, db_runtime).once

      described_class.handle_process_action_event(event)

      requests = described_class.instance_variable_get('@requests')
      expect(requests.keys.first).to eq(action: action, format: format, method: method, path: path)
      expect(requests.values.first).to be_a(RailsRequestStats::RequestStats)
    end
  end
end
