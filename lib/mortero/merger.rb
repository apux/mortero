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

  class AttributesArray < Array
    def merge_hash(hash)
      @hash = hash
      if duplicated?
        merge_nested_attributes!
      else
        self << hash
      end
    end

  private

    def duplicated?
      !!duplicated
    end

    def duplicated
      find do |hash_to_compare|
        keys_to_compare.all? { |k| @hash[k] == hash_to_compare[k] }
      end
    end

    def keys_to_compare
      @hash.keys.keep_if { |k| !k.to_s.end_with?("_attributes") }
    end

    def keys_to_merge
      @hash.keys.keep_if { |k| k.to_s.end_with?("_attributes") }
    end

    def merge_nested_attributes!
      duplicated_hash = duplicated
      keys_to_merge.each do |k|
        duplicated_hash[k] = evaluate_merge(duplicated_hash, k) if @hash[k]
      end
    end

    def evaluate_merge(duplicated_hash, k)
      if duplicated_hash[k].kind_of?(Array)
        Merger.new(duplicated_hash[k] + @hash[k]).merge
      else
        Merger.new([duplicated_hash[k], @hash[k]]).merge.last
      end
    end
  end

end
