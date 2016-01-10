require 'spec_helper'

describe RailsRequestStats::Stats::ObjectSpaceStats do
  describe '#add_stats' do
    it 'stores values' do
      before_object_space = {
        TOTAL: 210000,
        FREE: 50000,
        T_OBJECT: 10000,
        T_CLASS: 10000,
        T_MODULE: 10000,
        T_FLOAT: 10000,
        T_STRING: 10000,
        T_REGEXP: 10000,
        T_ARRAY: 10000,
        T_HASH: 10000,
        T_STRUCT: 10000,
        T_BIGNUM: 10000,
        T_FILE: 10000,
        T_DATA: 10000,
        T_MATCH: 10000,
        T_COMPLEX: 10000,
        T_NODE: 10000,
        T_ICLASS: 10000
      }

      after_object_space = {
        TOTAL: 420000,
        FREE: 100000,
        T_OBJECT: 20000,
        T_CLASS: 20000,
        T_MODULE: 20000,
        T_FLOAT: 20000,
        T_STRING: 20000,
        T_REGEXP: 20000,
        T_ARRAY: 20000,
        T_HASH: 20000,
        T_STRUCT: 20000,
        T_BIGNUM: 20000,
        T_FILE: 20000,
        T_DATA: 20000,
        T_MATCH: 20000,
        T_COMPLEX: 20000,
        T_NODE: 20000,
        T_ICLASS: 20000
      }

      subject.add_stats(before_object_space, after_object_space)

      expect(subject.object_count_collection).to eq([10000])
      expect(subject.class_count_collection).to eq([10000])
      expect(subject.module_count_collection).to eq([10000])
      expect(subject.float_count_collection).to eq([10000])
      expect(subject.string_count_collection).to eq([10000])
      expect(subject.regexp_count_collection).to eq([10000])
      expect(subject.array_count_collection).to eq([10000])
      expect(subject.hash_count_collection).to eq([10000])
      expect(subject.struct_count_collection).to eq([10000])
      expect(subject.bignum_count_collection).to eq([10000])
      expect(subject.file_count_collection).to eq([10000])
      expect(subject.data_count_collection).to eq([10000])
      expect(subject.match_count_collection).to eq([10000])
      expect(subject.complex_count_collection).to eq([10000])
      expect(subject.node_count_collection).to eq([10000])
      expect(subject.iclass_count_collection).to eq([10000])
      expect(subject.generated_object_count_collection).to eq([160000])
    end
  end

  describe '#total_object_space_count' do
    it 'calculates correct value' do
      object_space = {
        TOTAL: 210000,
        FREE: 50000,
        T_OBJECT: 10000,
        T_CLASS: 10000,
        T_MODULE: 10000,
        T_FLOAT: 10000,
        T_STRING: 10000,
        T_REGEXP: 10000,
        T_ARRAY: 10000,
        T_HASH: 10000,
        T_STRUCT: 10000,
        T_BIGNUM: 10000,
        T_FILE: 10000,
        T_DATA: 10000,
        T_MATCH: 10000,
        T_COMPLEX: 10000,
        T_NODE: 10000,
        T_ICLASS: 10000
      }
      expect(subject.total_object_space_count(object_space)).to eq(160000)
    end
  end

  describe '#last_stats_generated_objects' do
    it 'returns hash of last stats generated objects' do
      expected_hash = {
        total_generated_objects: 160000,
        object: 10000,
        class: 10000,
        module: 10000,
        float: 10000,
        string: 10000,
        regexp: 10000,
        array: 10000,
        hash: 10000,
        struct: 10000,
        bignum: 10000,
        file: 10000,
        data: 10000,
        match: 10000,
        complex: 10000,
        node: 10000,
        iclass: 10000
      }

      allow(subject).to receive(:generated_object_count_collection) { [160000] }
      allow(subject).to receive(:object_count_collection) { [10000] }
      allow(subject).to receive(:class_count_collection) { [10000] }
      allow(subject).to receive(:module_count_collection) { [10000] }
      allow(subject).to receive(:float_count_collection) { [10000] }
      allow(subject).to receive(:string_count_collection) { [10000] }
      allow(subject).to receive(:regexp_count_collection) { [10000] }
      allow(subject).to receive(:array_count_collection) { [10000] }
      allow(subject).to receive(:hash_count_collection) { [10000] }
      allow(subject).to receive(:struct_count_collection) { [10000] }
      allow(subject).to receive(:bignum_count_collection) { [10000] }
      allow(subject).to receive(:file_count_collection) { [10000] }
      allow(subject).to receive(:data_count_collection) { [10000] }
      allow(subject).to receive(:match_count_collection) { [10000] }
      allow(subject).to receive(:complex_count_collection) { [10000] }
      allow(subject).to receive(:node_count_collection) { [10000] }
      allow(subject).to receive(:iclass_count_collection) { [10000] }

      expect(subject.last_stats_generated_objects).to eq(expected_hash)
    end
  end
end
