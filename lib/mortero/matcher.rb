module Mortero
  class Matcher
    attr_reader :from, :to

    def initialize(from:, to:, &block)
      @from        = from
      @original_to = to
      @to          = convert_to_attribute_name(to)
      @block       = block if block_given?
    end

    def value(hash)
      @block ? @block.call(hash[from]) : hash[from]
    end

    def nested_attributes?
      false
    end

    def has_many?
      false
    end

  private

    def convert_to_attribute_name(to)
      to
    end
  end

  module NestedAttributes
    attr_reader :matchers

    def initialize(from: nil, to: nil, &block)
      super
      @matchers = []
    end

    def nested_attributes?
      true
    end

    def fields(hash, &block)
      hash.each_pair do |k, v|
        @matchers << Matcher.new(from: v, to: k, &block)
      end
    end

    def has_many(attribute_name, &block)
      matcher = HasManyMatcher.new(to: attribute_name)
      matcher.instance_eval &block if block_given?
      @matchers << matcher
    end

    def has_one(attribute_name, &block)
      matcher = HasOneMatcher.new(to: attribute_name)
      matcher.instance_eval &block if block_given?
      @matchers << matcher
    end

  private

    def convert_to_attribute_name(to)
      (to.to_s + '_attributes').to_sym if to
    end
  end

  class HasManyMatcher < Matcher
    include NestedAttributes

    def has_many?
      true
    end

  end

  class HasOneMatcher < Matcher
    include NestedAttributes

    def has_many?
      false
    end
  end
end
