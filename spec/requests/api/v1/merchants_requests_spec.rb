require 'rails_helper'

RSpec.describe "Merchants endpoints" do
  before(:each) do
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
    
    get "/api/v1/posters?sort=desc"
    posters = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    expect(posters[:data].count).to eq(3)

    expect(@merchant_3[:data][0][:attributes][:name]).to eq("Brown and Dads")
    expect(@merchant_2[:data][1][:attributes][:name]).to eq("Brown and Moms")
    expect(@merchant_1[:data][2][:attributes][:name]).to eq("Brown and Sons")
  end
  
  
  # get all merchants with calculated count of items
  it "can return the total merchant count" do
    
    get "/api/v1/merchants?sorted=age"
    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    
    expect(merchants).to have_key(:meta)
    expect(merchants[:meta][:count]).to eq(3)
    expect(posters[:data].count).to eq(3)
  end


  it "Can count the number of returned posters displayed" do

    get "/api/v1/posters"

    expect(response).to be_successful

    posters = JSON.parse(response.body, symbolize_names: true)

    expect(posters).to have_key(:meta)
    expect(posters[:meta][:count]).to eq(3)

    expect(posters[:data].count).to eq(3)
  end
  
  # get all merchants with returned items (check invoice)


end
  