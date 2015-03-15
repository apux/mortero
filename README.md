# Mortero

  Merge an array of hashes into grouped hashes with nested attributes (useful when importing from excel).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mortero'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mortero

## Usage

```ruby
hashes = [
  {
    "Company Name" => "My Company Inc.",
    "Web Page" => "www.mycompany.com",
    "Magazine" => "Automobile Today",
    "Section" => "News"
  }, 
  {
    "Company Name" => "My Company Inc.",
    "Web Page" => "www.mycompany.com",
    "Magazine" => "Automobile Today",
    "Section" => "Reviews"
  },
  {
    "Company Name" => "My Company Inc.",
    "Web Page" => "www.mycompany.com",
    "Magazine" => "Moto Today",
    "Section" => "News"
  },
  {
    "Company Name" => "My Company Inc.",
    "Web Page" => "www.mycompany.com",
    "Magazine" => "Moto Today",
    "Section" => "Routes"
  },
  {
    "Company Name" => "My Second Company Inc.",
    "Web Page" => "www.mycompany2.com",
    "Magazine" => "Computers & Gadgets",
    "Section" => "Laptops"
  },
  {
    "Company Name" => "My Second Company Inc.",
    "Web Page" => "www.mycompany2.com",
    "Magazine" => "Computers & Gadgets",
    "Section" => "Desktop"
  },
  {
    "Company Name" => "My Second Company Inc.",
    "Web Page" => "www.mycompany2.com",
    "Magazine" => "Computers & Gadgets",
    "Section" => "Mobile"
  },
]
Mortero.convert(hashes) do
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
# => [
#  {
#    name: "My Company Inc.",
#    contact_info_attributes: { page: "www.mycompany.com" },
#    magazines_attributes: [
#      { 
#        name: "Automobile Today",
#        sections_attributes: [
#          { name: "News" },
#          { name: "Reviews" }
#        ] 
#      },
#      {
#        name: "Moto Today",
#        sections_attributes: [
#          { name: "News" },
#          { name: "Routes" }
#        ]
#      }
#    ]
#  },
#  {
#    name: "My Second Company Inc.",
#    contact_info_attributes: { page: "www.mycompany2.com" },
#    magazines_attributes: [
#      {
#        name: "Computers & Gadgets",
#        sections_attributes: [
#         { name: "Laptops" },
#         { name: "Desktop" },
#         { name: "Mobile" }
#       ]
#     }
#   ]
# },
#]
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mortero/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
