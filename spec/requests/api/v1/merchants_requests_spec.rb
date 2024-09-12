require 'rails_helper'

RSpec.describe "Merchants endpoints" do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Brown and Sons")
    @merchant_2 = Merchant.create!(name: "Brown and Moms")
    @merchant_3 = Merchant.create!(name: "Brown and Dads")
  end

  it "can retrieve ALL merchants" do
    
    get "/api/v1/merchants"
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to be_successful
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)

      expect(@merchant_1.name).to eq("Brown and Sons")
      expect(@merchant_2.name).to eq("Brown and Moms")
      expect(@merchant_3.name).to eq("Brown and Dads")
    end
  end

  xit "can return the count" do

    get "/api/v1/merchants?sorted=age"

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to be_successful
  end
end
  