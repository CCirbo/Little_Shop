require 'rails_helper'

RSpec.describe "Item Merchants", type: :request do 
  it "returns items based on merchant id" do 
    merchant = Merchant.create!(id: 1, name: "Test Merchant")
    Item.create!(name: "Mouse", description: "Clicks", unit_price:100.99 , merchant_id: merchant.id)
    Item.create!(name: "Keyboard", description: "Types", unit_price:10.99 , merchant_id: merchant.id)
    Item.create!(name: "Pad", description: "Soft", unit_price:120.99 , merchant_id: merchant.id)
    Item.create!(name: "Notebook", description: "Gets Written On", unit_price:120.99 , merchant_id: merchant.id)

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    item_response = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(item_response.size).to eq(4)

    item_response.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to be_a(String)
      
      expect(item).to have_key(:attributes)
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to eq(merchant.id)
    end
  end

  it "sad-path handles an exception gracefully with a error message" do 
    get "/api/v1/merchants/9999/items"

    expect(response).to have_http_status(404)
    
    json_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(json_response).to have_key(:message)
    expect(json_response[:message]).to be_a(String)

    expect(json_response).to have_key(:errors)
    expect(json_response[:errors]).to be_a(Array)

    error = json_response[:errors].first

    expect(error).to have_key(:status)
    expect(error[:status]).to be_a(String)

    expect(error).to have_key(:title)
    expect(error[:title]).to be_a(String)
  end 
end