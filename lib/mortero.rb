require "mortero/version"
require "mortero/generator"
require "mortero/matcher"
require "mortero/merger"

module Mortero
  class << self
    def convert(hashes, &block)
      generated_hashes = generate(hashes, &block)
      merge(generated_hashes)
    end

  private

    def generate(hashes, &block)
      Generator.new(hashes, matcher(&block)).convert
    end

    def merge(hashes)
      Merger.new(hashes).merge
    end

    def matcher(&block)
      matcher = HasManyMatcher.new
      matcher.instance_eval &block
      matcher
    end
  end
end
