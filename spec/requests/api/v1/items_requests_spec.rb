require 'rails_helper'

RSpec.configure do |config| 
  config.formatter = :documentation 
end

RSpec.describe "Items endpoints" do
  it "can send a list of items" do
    Merchant.create!(id: 1, name: "Test Merchant")
    Merchant.create!(id: 2, name: "Test Merchant")
    Merchant.create!(id: 3, name: "Test Merchant")
    Merchant.create!(id: 4, name: "Test Merchant")
    Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id:1)
    Item.create!(name: "Keyboard", description: "Types", unit_price:10.99 , merchant_id:2)
    Item.create!(name: "Pad", description: "Soft", unit_price:120.99 , merchant_id:3)
    Item.create!(name: "Notebook", description: "Gets Written On", unit_price:120.99 , merchant_id:4)

    get "/api/v1/items"
    
    items = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    items.each do |item|

      expect(item).to have_key(:id)
      expect(item[:id]).to be_an(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)

      expect(item).to have_key(:attributes)
      attributes = item[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to be_a(String)

      expect(attributes).to have_key(:unit_price)
      expect(attributes[:unit_price]).to be_a(Float)

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
    end
  end

  it 'can create a new item' do
    item_params = {
    name: "New Item",
    description: "A cool new item",
    unit_price: 49.99,
    merchant_id: 1
    }

    headers = {"CONTENT_TYPE" => "application/json"}

    Merchant.create!(id: 1, name: "Test Merchant")

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)

    puts response.status
    puts response.body

    created_item = Item.last

    expect(response).to be_successful

    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
    expect(created_item.merchant_id).to eq(item_params[:merchant_id])

    item = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(item).to have_key(:id)
    expect(item[:id]).to be_an(String)

    expect(item).to have_key(:type)
    expect(item[:type]).to be_a(String)

    expect(item).to have_key(:attributes)
    attributes = item[:attributes]
    
    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)

    expect(attributes).to have_key(:description)
    expect(attributes[:description]).to be_a(String)

    expect(attributes).to have_key(:unit_price)
    expect(attributes[:unit_price]).to be_a(Float)

    expect(attributes).to have_key(:merchant_id)
    expect(attributes[:merchant_id]).to be_a(Integer)
  end
end