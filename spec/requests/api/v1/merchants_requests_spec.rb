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
    end

    it "can return the count" do
        merchant1 = Merchant.create!(name: "Brown and Sons")
        merchant2 = Merchant.create!(name: "Brown and Moms")
        merchant3 = Merchant.create!(name: "Brown and Dads")

        get "/api/v1/merchants", params: { count: true } #?count= true
        merchants = JSON.parse(response.body, symbolize_names: true)[:data]
        
        expect(response).to be_successful
    end
end
  