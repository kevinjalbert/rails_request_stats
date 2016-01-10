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
end
