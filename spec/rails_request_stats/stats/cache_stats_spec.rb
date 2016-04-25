require 'spec_helper'

describe RailsRequestStats::Stats::CacheStats do
  describe '#add_stats' do
    it 'stores values' do
      cache_read_count = 10
      cache_hit_count = 5

      subject.add_stats(cache_read_count, cache_hit_count)

      expect(subject.cache_read_count_collection).to eq([cache_read_count])
      expect(subject.cache_hit_count_collection).to eq([cache_hit_count])
    end
  end
end
