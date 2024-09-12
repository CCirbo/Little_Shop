require 'rails_helper'

RSpec.configure do |config| 
  config.formatter = :documentation 
end

RSpec.describe "Merchants endpoints" do
  it "can send a list of merchants" do
    merchant1 = Merchant.create!(name: "Brown and Sons")
    merchant2 = Merchant.create!(name: "Brown and Moms")
    merchant3 = Merchant.create!(name: "Brown and Dads")

    get "/api/v1/merchants"
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to be_successful

    merchants.each do |merchant|

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

  # it "can return the count" do
  #   merchant1 = Merchant.create!(name: "Brown and Sons")
  #   merchant2 = Merchant.create!(name: "Brown and Moms")
  #   merchant3 = Merchant.create!(name: "Brown and Dads")

  #   get "/api/v1/merchants?sorted=age"

  #   merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
  #   expect(response).to be_successful
  # end
end
  