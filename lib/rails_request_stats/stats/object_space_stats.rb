module RailsRequestStats
  module Stats
    class ObjectSpaceStats
      attr_reader :object_count_collection,
                  :class_count_collection,
                  :module_count_collection,
                  :float_count_collection,
                  :string_count_collection,
                  :regexp_count_collection,
                  :array_count_collection,
                  :hash_count_collection,
                  :struct_count_collection,
                  :bignum_count_collection,
                  :file_count_collection,
                  :data_count_collection,
                  :match_count_collection,
                  :complex_count_collection,
                  :node_count_collection,
                  :iclass_count_collection,
                  :generated_object_count_collection

      def initialize
        @object_count_collection = []
        @class_count_collection = []
        @module_count_collection = []
        @float_count_collection = []
        @string_count_collection = []
        @regexp_count_collection = []
        @array_count_collection = []
        @hash_count_collection = []
        @struct_count_collection = []
        @bignum_count_collection = []
        @file_count_collection = []
        @data_count_collection = []
        @match_count_collection = []
        @complex_count_collection = []
        @node_count_collection = []
        @iclass_count_collection = []
        @generated_object_count_collection = []
      end

      def add_stats(before_object_space, after_object_space)
        @object_count_collection << after_object_space[:T_OBJECT] - before_object_space[:T_OBJECT]
        @class_count_collection << after_object_space[:T_CLASS] - before_object_space[:T_CLASS]
        @module_count_collection << after_object_space[:T_MODULE] - before_object_space[:T_MODULE]
        @float_count_collection << after_object_space[:T_FLOAT] - before_object_space[:T_FLOAT]
        @string_count_collection << after_object_space[:T_STRING] - before_object_space[:T_STRING]
        @regexp_count_collection << after_object_space[:T_REGEXP] - before_object_space[:T_REGEXP]
        @array_count_collection << after_object_space[:T_ARRAY] - before_object_space[:T_ARRAY]
        @hash_count_collection << after_object_space[:T_HASH] - before_object_space[:T_HASH]
        @struct_count_collection << after_object_space[:T_STRUCT] - before_object_space[:T_STRUCT]
        @bignum_count_collection << after_object_space[:T_BIGNUM] - before_object_space[:T_BIGNUM]
        @file_count_collection << after_object_space[:T_FILE] - before_object_space[:T_FILE]
        @data_count_collection << after_object_space[:T_DATA] - before_object_space[:T_DATA]
        @match_count_collection << after_object_space[:T_MATCH] - before_object_space[:T_MATCH]
        @complex_count_collection << after_object_space[:T_COMPLEX] - before_object_space[:T_COMPLEX]
        @node_count_collection << after_object_space[:T_NODE] - before_object_space[:T_NODE]
        @iclass_count_collection << after_object_space[:T_ICLASS] - before_object_space[:T_ICLASS]
        @generated_object_count_collection << total_object_space_count(after_object_space) - total_object_space_count(before_object_space)
      end

      def total_object_space_count(object_space)
        object_space.select { |k, v| k.to_s.start_with?('T_') }.values.reduce(:+)
      end
    end
  end
end
