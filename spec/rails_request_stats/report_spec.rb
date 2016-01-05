require 'spec_helper'

describe RailsRequestStats::Report do
  let(:request_stats) do
    action = 'index'
    format = :html
    method = 'GET'
    path = '/users'

    RailsRequestStats::RequestStats.new(action: action, format: format, method: method, path: path)
  end

  let(:categories) { [:view_runtime, :db_runtime, :query_count, :cached_query_count] }
  let(:stat_values) { [5, 20, 10] }

  subject { described_class.new(request_stats) }

  before do
    stat_values.each do |value|
      request_stats.add_stats(value, value, value, value, value)
    end
  end

  describe '#report_text' do
    it 'returns report_text of last added stats' do
      expected_report_text = '[RailsRequestStats] (AVG view_runtime: 11.6667ms | AVG db_runtime: 11.6667ms | AVG generated_object_count: 11.6667 | query_count: 10 | cached_query_count: 10)'
      expect(subject.report_text).to eq(expected_report_text)
    end
  end

  describe '#exit_report_text' do
    it 'returns exit_report_text of request stats' do
      expected_exit_report_text = '[RailsRequestStats] INDEX:html "/users" (AVG view_runtime: 11.6667ms | AVG db_runtime: 11.6667ms | AVG generated_object_count: 11.6667 | MIN query_count: 5 | MAX query_count: 20) from 3 requests'
      expect(subject.exit_report_text).to eq(expected_exit_report_text)
    end
  end

  describe '#min_stat' do
    it 'returns min stat value for specified category' do
      categories.each do |category|
        expect(subject.min_stat(category)).to eq(stat_values.min)
      end
    end
  end

  describe '#max_stat' do
    it 'returns max stat value for specified category' do
      categories.each do |category|
        expect(subject.max_stat(category)).to eq(stat_values.max)
      end
    end
  end

  describe '#total_stat' do
    it 'returns total stat value for specified category' do
      categories.each do |category|
        expect(subject.total_stat(category)).to eq(stat_values.reduce(:+))
      end
    end
  end

  describe '#count_stat' do
    it 'returns count stat value for specified category' do
      categories.each do |category|
        expect(subject.count_stat(category)).to eq(stat_values.size)
      end
    end
  end

  describe '#last_stat' do
    it 'returns last stat value for specified category' do
      categories.each do |category|
        expect(subject.last_stat(category)).to eq(stat_values.last)
      end
    end
  end

  describe '#avg_stat' do
    it 'returns avg stat value for specified category' do
      categories.each do |category|
        expect(subject.avg_stat(category)).to eq(stat_values.reduce(:+).to_f / stat_values.size)
      end
    end
  end
end
