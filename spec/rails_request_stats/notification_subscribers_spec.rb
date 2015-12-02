require 'spec_helper'

describe RailsRequestStats::NotificationSubscribers do
  before(:each) do
    described_class.reset_query_counts
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

  describe 'process_action.action_controller subscription works' do
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

  describe '.handle_process_action_event' do
    it 'processes controller action event' do
      action = 'index'
      format = :html
      method = 'GET'
      path = '/users'
      view_runtime = 175.11533110229672
      db_runtime = 15.542000000000002

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

      expect(described_class).to receive(:reset_query_counts).once

      described_class.handle_process_action_event(event)
      requests = described_class.instance_variable_get('@requests')

      expect(requests.keys.first).to eq(action: action, format: format, method: method, path: path)
      expect(requests.values.first).to be_a(RailsRequestStats::RequestStats)
      expect(requests.values.first.view_runtime_collection).to eq([view_runtime])
      expect(requests.values.first.db_runtime_collection).to eq([db_runtime])
    end
  end
end
