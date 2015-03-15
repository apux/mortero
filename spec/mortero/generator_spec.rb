require "spec_helper"

RSpec.describe Mortero::Generator do
  let(:matcher) { Mortero::HasManyMatcher.new } 

  describe "#convert" do
    it "converts simple hashes based on the given matcher" do
      hashes = [
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com" }
      ]
      matcher.fields name: "Company Name", page: "Web Page"
      generator = Mortero::Generator.new(hashes, matcher)
      expect(generator.convert).to eq [
        { name: "My Company Inc.", page: "www.mycompany.com" },
        { name: "My Second Company Inc.", page: "www.mycompany2.com" }
      ]
    end

    it "converts hashes with 'has_many' based on the given matcher" do
      hashes = [
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Automobile Today" },
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Moto Today" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets" }
      ]
      matcher.fields name: "Company Name", page: "Web Page"
      matcher.has_many :magazines do   
        fields name: "Magazine"
      end
      generator = Mortero::Generator.new(hashes, matcher)
      expect(generator.convert).to eq [
        { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today" }] },
        { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Moto Today" }] },
        { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets" }] }
      ]
    end

    it "converts hashes with 'has_one' based on the given matcher" do
      hashes = [
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com" },
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.org" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com" },
      ]
      matcher.fields name: "Company Name"
      matcher.has_one :contact_info do
        fields page: "Web Page"
      end
      generator = Mortero::Generator.new(hashes, matcher)
      expect(generator.convert).to eq [
        { name: "My Company Inc.", contact_info_attributes: { page: "www.mycompany.com" } },
        { name: "My Company Inc.", contact_info_attributes: { page: "www.mycompany.org" } },
        { name: "My Second Company Inc.", contact_info_attributes: { page: "www.mycompany2.com" } },
      ]
    end

    it "converts hashes with multiple 'has_one' and 'has_many' based on the given matcher" do
      hashes = [
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Automobile Today", "Section" => "News" }, 
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Automobile Today", "Section" => "Reviews" },
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Moto Today", "Section" => "News" },
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Moto Today", "Section" => "Routes" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets", "Section" => "Laptops" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets", "Section" => "Desktop" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets", "Section" => "Mobile" },
      ]
      matcher.fields name: "Company Name", page: "Web Page"
      matcher.has_many :magazines do
        fields name: "Magazine"
        has_many :sections do
          fields name: "Section"
        end
      end
      generator = Mortero::Generator.new(hashes, matcher)
      expect(generator.convert).to eq [
        { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "News" } ] }] },
        { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "Reviews" } ] }] },
        { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Moto Today", sections_attributes: [ { name: "News" } ] }] },
        { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Moto Today", sections_attributes: [ { name: "Routes" } ] }] },
        { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Laptops" } ] }] },
        { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Desktop" } ] }] },
        { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Mobile" } ] }] },
      ]
    end

    it "converts simple hashes based on the given matcher with blocks" do
      hashes = [
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com     " },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "       www.mycompany2.com" }
      ]
      matcher.fields name: "Company Name" do |v|
        v.upcase
      end

      matcher.fields page: "Web Page" do |v|
        v.strip
      end

      generator = Mortero::Generator.new(hashes, matcher)
      expect(generator.convert).to eq [
        { name: "MY COMPANY INC.", page: "www.mycompany.com" },
        { name: "MY SECOND COMPANY INC.", page: "www.mycompany2.com" }
      ]
    end
  end
end
