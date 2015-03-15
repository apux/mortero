require "spec_helper"

RSpec.describe Mortero::Matcher do
  it "stores the 'from' and 'to' attributes" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher.from).to eq "Company Name"
    expect(matcher.to).to eq :name
  end

  it "is not a nested_attributes matcher" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher).not_to be_nested_attributes
  end

  it "is not a has_many matcher" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher).not_to be_has_many
  end

  describe "#value" do
    it "evaluates the block when a block is given" do
      matcher = described_class.new(from: "Company Name", to: :name) do |v|
        v.upcase
      end
      expect(matcher.value({"Company Name" => "My Company Inc."})).to eq "MY COMPANY INC."
    end

    it "returns the value if no block is given" do
      matcher = described_class.new(from: "Company Name", to: :name)
      expect(matcher.value({"Company Name" => "My Company Inc."})).to eq "My Company Inc."
    end
  end # describe #value
end

shared_examples_for "a nested attributes matcher"  do
  it "is a nested_attributes matcher" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher).to be_nested_attributes
  end

  it "adds '_attributes' as suffix to the 'to' name" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher.to).to eq :name_attributes
  end

  it "accepts the 'from' and 'to' to be missing" do
    matcher = described_class.new()
    expect(matcher.from).to eq nil
    expect(matcher.to).to eq nil
  end

  describe "#fields" do
    it "creates one matcher when receiving a has with one key-value" do
      matcher = described_class.new
      matcher.fields name: "Company Name"
      expect(matcher.matchers.size).to eq 1
    end

    it "creates a matcher with the correct values" do
      matcher = described_class.new
      matcher.fields name: "Company Name"
      expect(matcher.matchers.first).to be_kind_of Mortero::Matcher
      expect(matcher.matchers.first.to).to eq :name
      expect(matcher.matchers.first.from).to eq "Company Name"
    end

    it "accepts a block for a matcher" do
      matcher = described_class.new
      matcher.fields name: "Company Name" do |v|
        v.upcase
      end
      expect(matcher.matchers.first.value({"Company Name" => "My Company Inc."})).to eq "MY COMPANY INC."
    end

    it "creates two matchers when receiving a has with two key-values" do
      matcher = described_class.new
      matcher.fields name: "Company Name", page: "Company page"
      expect(matcher.matchers.size).to eq 2
    end

    it "creates two matchers when receiven two hashes separately" do
      matcher = described_class.new
      matcher.fields name: "Company Name"
      matcher.fields page: "Company page"
      expect(matcher.matchers.size).to eq 2
    end

  end # describe #fields

  describe "#has_many" do
    it "creates a HasManyMatcher" do
      matcher = described_class.new
      matcher.has_many :names do
        # empty block
      end
      expect(matcher.matchers.size).to eq 1
      expect(matcher.matchers.first).to be_kind_of Mortero::HasManyMatcher
    end

    it "evaluates the given block into the HasManyMatcher object" do
      matcher = described_class.new
      matcher.has_many :names do
        fields name: "Company Name"
      end
      expect(matcher.matchers.first.matchers.size).to eq 1
      expect(matcher.matchers.first.matchers.first).to be_a_kind_of Mortero::Matcher
    end
  end # describe #has_many

  describe "#has_one" do
    it "creates a HasOneMatcher" do
      matcher = described_class.new
      matcher.has_one :names do
      end
      expect(matcher.matchers.size).to eq 1
      expect(matcher.matchers.first).to be_kind_of Mortero::HasOneMatcher
    end

    it "evaluates the given block into the HasOneMatcher object" do
      matcher = described_class.new
      matcher.has_one :names do
        fields name: "Company Name"
      end
      expect(matcher.matchers.first.matchers.size).to eq 1
      expect(matcher.matchers.first.matchers.first).to be_a_kind_of Mortero::Matcher
    end
  end # describe #has_one
end

RSpec.describe Mortero::HasManyMatcher do
  it "is a has_many matcher" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher).to be_has_many
  end

  it_behaves_like "a nested attributes matcher"
end

RSpec.describe Mortero::HasOneMatcher do
  it "is not a has_many matcher" do
    matcher = described_class.new(from: "Company Name", to: :name)
    expect(matcher).not_to be_has_many
  end

  it_behaves_like "a nested attributes matcher"
end
