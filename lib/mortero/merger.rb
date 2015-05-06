module Mortero
  class Merger
    def initialize(hashes)
      @hashes = hashes
    end

    def merge
      @hashes.each.with_object(AttributesArray.new) do |hash, array|
        array.merge_hash(hash)
      end.to_a
    end
  end

  module AttributesHashHelpers
    refine Hash do
      def same_attributes?(hash_to_compare)
        keys_to_compare.all? { |k| self[k] == hash_to_compare[k] }
      end

      def merge_nested_attributes!(hash)
        keys_to_merge.each do |k|
          self[k] = evaluate_merge(hash, k) if hash[k]
        end
      end

      private

      def keys_to_compare
        keys.keep_if { |k| !k.to_s.end_with?("_attributes") }
      end

      def keys_to_merge
        keys.keep_if { |k| k.to_s.end_with?("_attributes") }
      end

      def evaluate_merge(hash, k)
        if hash[k].kind_of?(Array)
          Merger.new(self[k] + hash[k]).merge
        else
          Merger.new([self[k], hash[k]]).merge.last
        end
      end
    end
  end

  class AttributesArray < Array
    using AttributesHashHelpers

    def merge_hash(hash)
      duplicated = find { |h| h.same_attributes?(hash) }
      if duplicated
        duplicated.merge_nested_attributes!(hash)
      else
        self << hash
      end
    end
  end

end
