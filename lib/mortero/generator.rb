module Mortero
  class Generator
    def initialize(hashes, matcher)
      @hashes = hashes
      @matcher = matcher
    end

    def convert
      @hashes.map do |hash|
        @matcher.matchers.map.with_object({}) do |matcher, generated|
          generated[matcher.to] = value_for(matcher, hash)
        end
      end
    end

  private

    def value_for(matcher, hash)
      if matcher.nested_attributes?
        values = Generator.new([hash], matcher).convert
        matcher.has_many? ? values : values.first
      else
        matcher.value(hash)
      end
    end
  end
end
