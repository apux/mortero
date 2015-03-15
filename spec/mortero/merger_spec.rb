require "spec_helper"

RSpec.describe Mortero::Merger do
  it "does not merge when the hashes don't share values" do
    hashes = [
      { name: "My Company Inc.", page: "www.mycompany.com" },
      { name: "My Second Company Inc.", page: "www.mycompany2.com" }
    ]
    merger = Mortero::Merger.new(hashes)
    expect(merger.merge).to eq [
      { name: "My Company Inc.", page: "www.mycompany.com" },
      { name: "My Second Company Inc.", page: "www.mycompany2.com" }
    ]
  end

  it "merges when the hases share values" do
    hashes = [
      { name: "My Company Inc.", page: "www.mycompany.com" },
      { name: "My Company Inc.", page: "www.mycompany.com" }
    ]
    merger = Mortero::Merger.new(hashes)
    expect(merger.merge).to eq [
      { name: "My Company Inc.", page: "www.mycompany.com" },
    ]
  end

  it "merges only not nested attributes" do
    hashes = [
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today" }] },
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Moto Today" }] },
      { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets" }] }
    ]
    merger = Mortero::Merger.new(hashes)
    expect(merger.merge).to eq [
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today" }, { name: "Moto Today" }] },
      { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets" }] }
    ]
  end

  it "merges nested attributes with multiple levels (hash_many)" do
    hashes = [
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "News" } ] }] },
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "Reviews" } ] }] },
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Moto Today", sections_attributes: [ { name: "News" } ] }] },
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Moto Today", sections_attributes: [ { name: "Routes" } ] }] },
      { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Laptops" } ] }] },
      { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Desktop" } ] }] },
      { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Mobile" } ] }] },
    ]
    merger = Mortero::Merger.new(hashes)
    expect(merger.merge).to eq [
      { name: "My Company Inc.", page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "News" }, { name: "Reviews" } ] }, { name: "Moto Today", sections_attributes: [ { name: "News" }, { name: "Routes" } ] }] },
      { name: "My Second Company Inc.", page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Laptops" }, { name: "Desktop" }, { name: "Mobile" } ] }] },
    ]
  end

  it "merges nested attributes with multiple levels (hash_one)" do
    hashes = [
      { name: "My Company Inc.", contact_info_attributes: { page: "www.mycompany.com" } },
      { name: "My Company Inc.", contact_info_attributes: { page: "www.mycompany.org" } },
      { name: "My Second Company Inc.", contact_info_attributes: { page: "www.mycompany2.com" } },
    ]
    merger = Mortero::Merger.new(hashes)
    expect(merger.merge).to eq [
      { name: "My Company Inc.", contact_info_attributes: { page: "www.mycompany.org" } },
      { name: "My Second Company Inc.", contact_info_attributes: { page: "www.mycompany2.com" } },
    ]
  end

  it "merges nested attributes with multiple levels (hash_many and has_one)" do
    hashes = [
      {     
        name: "My Company Inc.",
        page: "www.mycompany.com",
        magazines_attributes: [
          { 
            name: "Automobile Today",
            sections_attributes: [
              { name: "News" }
            ]
          } 
        ],  
        contact_info_attributes: {
          emails_attributes: [
            { address: "mail1@mycompany.com" },
            { address: "mail2@mycompany.com" },
            { address: "mail3@mycompany.com" },
          ]
        }
      },
      {
        name: "My Company Inc.",
        page: "www.mycompany.com",
        magazines_attributes: [
          {
            name: "Automobile Today",
            sections_attributes: [
              { name: "Reviews" }
            ]
          }
        ],
        contact_info_attributes: {
          emails_attributes: [
            { address: "mail4@mycompany.com" },
            { address: "mail5@mycompany.com" },
            { address: "mail6@mycompany.com" },
          ]
        }
      },
      {
        name: "My Company Inc.",
        page: "www.mycompany.com",
        magazines_attributes: [
          {
            name: "Moto Today",
            sections_attributes: [
              { name: "News" }
            ]
          }
        ]
      },
      {
        name: "My Company Inc.",
        page: "www.mycompany.com",
        magazines_attributes: [
          {
            name: "Moto Today",
            sections_attributes: [
              { name: "Routes" }
            ]
          }
        ]
      },
      {
        name: "My Second Company Inc.",
        page: "www.mycompany2.com",
        magazines_attributes: [
          {
            name: "Computers & Gadgets",
            sections_attributes: [
              { name: "Laptops" }
            ]
          }
        ],
        contact_info_attributes: {
          emails_attributes: [
            { address: "mail4@mycompany2.com" },
            { address: "mail5@mycompany2.com" },
            { address: "mail6@mycompany2.com" },
          ]
        }
      },
      {
        name: "My Second Company Inc.",
        page: "www.mycompany2.com",
        magazines_attributes: [
          {
            name: "Computers & Gadgets",
            sections_attributes: [
              { name: "Desktop" }
            ]
          }
        ]
      },
      {
        name: "My Second Company Inc.",
        page: "www.mycompany2.com",
        magazines_attributes: [
          {
            name: "Computers & Gadgets",
            sections_attributes: [
              { name: "Mobile" }
            ]
          }
        ]
      },
    ]
    merger = Mortero::Merger.new(hashes)
    expect(merger.merge).to eq [
      { name: "My Company Inc.", contact_info_attributes: { emails_attributes: [ { address: "mail1@mycompany.com" }, { address: "mail2@mycompany.com" }, { address: "mail3@mycompany.com" }, { address: "mail4@mycompany.com" }, { address: "mail5@mycompany.com" }, { address: "mail6@mycompany.com" } ] }, page: "www.mycompany.com", magazines_attributes: [{ name: "Automobile Today", sections_attributes: [ { name: "News" }, { name: "Reviews" } ] }, { name: "Moto Today", sections_attributes: [ { name: "News" }, { name: "Routes" } ] }] },
      { name: "My Second Company Inc.", contact_info_attributes: { emails_attributes: [ { address: "mail4@mycompany2.com" }, { address: "mail5@mycompany2.com" }, { address: "mail6@mycompany2.com" } ] }, page: "www.mycompany2.com", magazines_attributes: [{ name: "Computers & Gadgets", sections_attributes: [ { name: "Laptops" }, { name: "Desktop" }, { name: "Mobile" } ] }] },
    ]
  end
end # describe Mortero::Merger
