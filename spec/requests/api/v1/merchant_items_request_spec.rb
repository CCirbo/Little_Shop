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
end

