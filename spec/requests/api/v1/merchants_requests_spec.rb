require 'rails_helper'

RSpec.describe "Merchants endpoints" do
  before(:each) do
    # How to create default status for returned/not returned?
    @merchant_1 = Merchant.create!(name: "Brown and Sons", created_at: 3.seconds.ago)
    @merchant_2 = Merchant.create!(name: "Brown and Moms", created_at: 2.seconds.ago)
    @merchant_3 = Merchant.create!(name: "Brown and Dads", created_at: 1.seconds.ago)

    @customer_1 = Customer.create!(first_name: "Johnny", last_name: "Carson")
    @customer_2 = Customer.create!(first_name: "King", last_name: "Louie")
    
    # WE DON'T NEED THESE YET
    # I GOT AHEAD OF MYSELF
    # @item_1 = Item.create!(name: "Shirt", description: "clothing", unit_price: 16, merchant_id: @merchant_1.id)
    # @item_2 = Item.create!(name: "Pants", description: "clothing", unit_price: 25, merchant_id: @merchant_1.id )
    # @item_3 = Item.create!(name: "Hat", description: "clothing", unit_price: 12, merchant_id: @merchant_1.id)
    # @item_4 = Item.create!(name: "H20 Bottle", description: "hydration", unit_price: 8, merchant_id: @merchant_3.id)
    # @item_5 = Item.create!(name: "Jersey", description: "fan gear", unit_price: 45, merchant_id: @merchant_3.id)
    # @item_6 = Item.create!(name: "Ball", description: "sports", unit_price: 36, merchant_id: @merchant_3.id)
    
    @invoice_1 = Invoice.create!(status: "not returned", customer_id: @customer_1.id, merchant_id: @merchant_1.id)
    @invoice_2 = Invoice.create!(status: "returned", customer_id: @customer_1.id, merchant_id: @merchant_1.id)
    @invoice_3 = Invoice.create!(status: "not returned", customer_id: @customer_1.id, merchant_id: @merchant_3.id)
    @invoice_4 = Invoice.create!(status: "returned", customer_id: @customer_2.id, merchant_id: @merchant_3.id)
    @invoice_5 = Invoice.create!(status: "returned", customer_id: @customer_2.id, merchant_id: @merchant_3.id)  
  end


  it "can retrieve ALL merchants" do
    
    get "/api/v1/merchants"
    get "/api/v1/items"

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
    
    get "/api/v1/merchants?sort=desc"
    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
  end

  describe "Fetch one merchant" do
    it "can return one merchant by its id" do
      id =  merchant1 = Merchant.create!(name: "Brown and Sons").id
      get "/api/v1/merchants/#{id}"
      merchant1 = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(response).to be_successful  
      expect(merchant1[:type]).to eq("merchant")

      expect(merchant1).to have_key(:id)
      expect(merchant1[:id]).to be_an(String)

      merchant1 = merchant1[:attributes]

      expect(merchant1).to have_key(:name)
      expect(merchant1[:name]).to be_a(String)
    end

    it "can update an existing merchant" do
      id = Merchant.create(name: "Brown and Sons",).id
      previous_name = Merchant.last.name
      merchant_params = { name: "Red and Sons" }
      headers = {"CONTENT_TYPE" => "application/json"}
  
      patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate({merchant: merchant_params})
      merchant = Merchant.find_by(id: id)

      expect(response).to be_successful
      expect(merchant.name).to_not eq(previous_name)
      expect(merchant.name).to eq("Red and Sons")

      expect(response).to be_successful
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    
    end

    it 'can create a new merchant' do
      merchant_params = {
        name: "Big Tims"
      }
  
      headers = {"CONTENT_TYPE" => "application/json"}
  
      post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
      created_merchant = Merchant.last
  
      expect(response).to be_successful
      expect(created_merchant.name).to eq(merchant_params[:name])
  
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
  
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_an(String)
  
      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)
  
      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end

    it 'can delete a merchant' do
      merchant = Merchant.create!(name: "Brown and Sons")
      item1 = merchant.items.create!(name: "Item 1" , unit_price: 20)
      item2 = merchant.items.create!(name: "Item 2", unit_price: 30)
      customer = Customer.create!(first_name: "John", last_name: "Doe")
      invoice1 = Invoice.create!(merchant: merchant, customer: customer, status: "pending")
      invoice2 = Invoice.create!(merchant: merchant, customer: customer, status: "completed")

      expect(merchant).to be_a(Merchant)
      expect(merchant).to be_present
      expect(Merchant.all).to include(merchant)
      expect(merchant.items).to include(item1, item2)
      expect(merchant.invoices).to include(invoice1, invoice2)
  
      expect{ delete "/api/v1/merchants/#{merchant.id}" }.to change(Merchant, :count).by(-1)

      expect{ Merchant.find(merchant.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Item.find(item1.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Item.find(item2.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Invoice.find(invoice1.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { Invoice.find(invoice2.id) }.to raise_error(ActiveRecord::RecordNotFound)

      expect(response).to have_http_status(:no_content)
    end
  end

  it 'returns merchants sorted by creation date (newest first)' do
    Merchant.create!(name: "Merchant A", created_at: 2.days.ago)
    Merchant.create!(name: "Merchant B", created_at: 1.day.ago)
    Merchant.create!(name: "Merchant C", created_at: Time.now)

    get "/api/v1/merchants?sorted=age"


    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    creation_dates = merchants.map { |merchant| DateTime.parse(merchant[:attributes][:created_at]) }

    expect(creation_dates).to eq(creation_dates.sort.reverse)
  end
end

 

  #   expect(merchants[:data][2][:attributes][:name]).to eq("Brown and Sons")
  #   expect(merchants[:data][1][:attributes][:name]).to eq("Brown and Moms")
  #   expect(merchants[:data][0][:attributes][:name]).to eq("Brown and Dads")
  # end
  
  
  # get all merchants with calculated count of items
  # THIS IS NOT CORRECT YET
  xit "can return the total merchant count" do
    
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
    
    expect(merchants[:data][0][:attributes][:name]).to eq(@merchant_1.name)
    expect(merchants[:data][2][:attributes][:name]).to eq(@merchant_3.name)
  end
end



 
