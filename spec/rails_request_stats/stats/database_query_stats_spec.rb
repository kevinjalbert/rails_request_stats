require 'spec_helper'

describe RailsRequestStats::Stats::DatabaseQueryStats do
  describe '#add_stats' do
    it 'stores values' do
      query_count = 10
      cached_query_count = 20

      subject.add_stats(query_count, cached_query_count)

      expect(subject.query_count_collection).to eq([query_count])
      expect(subject.cached_query_count_collection).to eq([cached_query_count])
    end
  end
end
