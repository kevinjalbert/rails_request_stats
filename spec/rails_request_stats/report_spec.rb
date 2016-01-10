require 'spec_helper'

describe RailsRequestStats::Report do
  let(:request_stats) do
    action = 'index'
    format = :html
    method = 'GET'
    path = '/users'

    RailsRequestStats::RequestStats.new(action: action, format: format, method: method, path: path)
  end

  subject { described_class.new(request_stats) }

  before do
    collection = [10, 5, 20]

    allow(request_stats.runtime_stats).to receive(:view_runtime_collection) { collection }
    allow(request_stats.runtime_stats).to receive(:db_runtime_collection) { collection }

    allow(request_stats.database_query_stats).to receive(:query_count_collection) { collection }
    allow(request_stats.database_query_stats).to receive(:cached_query_count_collection) { collection }

    allow(request_stats.object_space_stats).to receive(:object_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:class_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:module_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:float_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:string_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:regexp_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:array_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:hash_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:struct_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:bignum_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:file_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:data_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:match_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:complex_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:node_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:iclass_count_collection) { collection }
    allow(request_stats.object_space_stats).to receive(:generated_object_count_collection) { collection }
  end

  describe '#report_text' do
    it 'returns report_text of last added stats' do
      expected_report_text = '[RailsRequestStats] (AVG view_runtime: 11.6667ms | AVG db_runtime: 11.6667ms | AVG generated_object_count: 11.6667 | query_count: 20 | cached_query_count: 20)'
      expect(subject.report_text).to eq(expected_report_text)
    end
  end

  describe '#exit_report_text' do
    it 'returns exit_report_text of request stats' do
      expected_exit_report_text = '[RailsRequestStats] INDEX:html "/users" (AVG view_runtime: 11.6667ms | AVG db_runtime: 11.6667ms | AVG generated_object_count: 11.6667 | MIN query_count: 5 | MAX query_count: 20) from 3 requests'
      expect(subject.exit_report_text).to eq(expected_exit_report_text)
    end
  end

  describe '#total' do
    it 'returns total stat for a collection' do
      collection = [10, 20, 30]
      expect_result = 60
      expect(subject.total(collection)).to eq(expect_result)
    end
  end

  describe '#avg' do
    it 'returns avg stat value for specified category' do
      collection = [10, 20, 30]
      expect_result = 60/collection.size
      expect(subject.avg(collection)).to eq(expect_result)
    end
  end
end
