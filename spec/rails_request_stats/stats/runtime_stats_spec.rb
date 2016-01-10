require 'spec_helper'

describe RailsRequestStats::Stats::RuntimeStats do
  describe '#add_stats' do
    it 'stores values' do
      view_runtime = 10.10
      db_runtime = 20.20

      subject.add_stats(view_runtime, db_runtime)

      expect(subject.view_runtime_collection).to eq([view_runtime])
      expect(subject.db_runtime_collection).to eq([db_runtime])
    end
  end
end
