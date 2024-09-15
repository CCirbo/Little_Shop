require 'rails_helper'

RSpec.describe "MerchantItems", type: :request do
  describe "GET /items/:id/merchant" do
    it "returns the merchant associated with an item" do
      merchant = Merchant.create!(id: 1, name: "Schroeder-Jerde")
      item = Item.create!(name: "Keyboard", description: "Types", unit_price:10.99 , merchant_id: merchant.id)
    
      get "/api/v1/items/#{item.id}/merchant"

      expect(response).to be_successful

      merchant_response = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant_response).to have_key(:id)
      expect(merchant_response[:id]).to be_a(String)

      expect(merchant_response).to have_key(:type)
      expect(merchant_response[:type]).to be_a(String)

      expect(merchant_response).to have_key(:attributes)
      expect(merchant_response[:attributes][:name]).to be_a(String)
    end
  end

  it 'handles an exception gracefully with a error message' do

    get "/api/v1/items/9999/merchant"

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

