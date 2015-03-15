require "spec_helper"

RSpec.describe Mortero do
  it "generates " do
      hashes = [
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Automobile Today", "Section" => "News" }, 
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Automobile Today", "Section" => "Reviews" },
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Moto Today", "Section" => "News" },
        { "Company Name" => "My Company Inc.", "Web Page" => "www.mycompany.com", "Magazine" => "Moto Today", "Section" => "Routes" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets", "Section" => "Laptops" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets", "Section" => "Desktop" },
        { "Company Name" => "My Second Company Inc.", "Web Page" => "www.mycompany2.com", "Magazine" => "Computers & Gadgets", "Section" => "Mobile" },
      ]
      converted_hashes = Mortero.convert(hashes) do
        fields name: "Company Name"
        has_one :contact_info do
          fields page: "Web Page"
        end
        has_many :magazines do
          fields name: "Magazine"
          has_many :sections do
            fields name: "Section"
          end
        end
      end
      expect(converted_hashes).to eq [
        { name: "My Company Inc.", contact_info_attributes: { page: "www.mycompany.com" }, magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "News" }, { name: "Reviews" } ] }, { name: "Moto Today", sections_attributes: [ { name: "News" }, { name: "Routes" } ] }] },
        { name: "My Second Company Inc.", contact_info_attributes: { page: "www.mycompany2.com" }, magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Laptops" }, { name: "Desktop" }, { name: "Mobile" } ] }] },
      ]
  end
end
