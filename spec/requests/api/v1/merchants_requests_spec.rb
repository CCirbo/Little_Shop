require 'rails_helper'

RSpec.describe "Merchants endpoints" do
  before(:each) do
    # How to create default status for returned/not returned?
    @merchant_1 = Merchant.create!(name: "Brown and Sons", created_at: 3.seconds.ago)
    @merchant_2 = Merchant.create!(name: "Brown and Moms", created_at: 2.seconds.ago)
    @merchant_3 = Merchant.create!(name: "Brown and Dads", created_at: 1.seconds.ago)
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

  
  # get all merchants sorted by newest to oldest
  it "sorts merchants by creation date" do
    
    get "/api/v1/merchants?sort=asc"
    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    expect(merchants[:data][0][:attributes][:name]).to eq("Brown and Sons")
    expect(merchants[:data][1][:attributes][:name]).to eq("Brown and Moms")
    expect(merchants[:data][2][:attributes][:name]).to eq("Brown and Dads")
  end
  
  
  # get all merchants with calculated count of items
  it "can return the total merchant count" do
    
    get "/api/v1/merchants?sorted=age"
    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    
    expect(merchants).to have_key(:meta)
    expect(merchants[:meta][:count]).to eq(3)
    expect(merchants[:data].count).to eq(3)
  end
  
  # get all merchants with returned items (check invoice)
  it "returns only merchants with returned items" do
    
    get "/api/v1/merchants?status=returned"
    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful

    # Add items & invoices (invoice_items?) and associate them with merchants.
    # Give them a status so we can sort them

  end

end

