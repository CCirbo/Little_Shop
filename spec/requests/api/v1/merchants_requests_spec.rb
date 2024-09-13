require 'rails_helper'

RSpec.describe "Merchants endpoints" do
  it "can send a list of merchants" do
    merchant1 = Merchant.create!(name: "Brown and Sons")
    merchant2 = Merchant.create!(name: "Brown and Moms")
    merchant3 = Merchant.create!(name: "Brown and Dads")

    get "/api/v1/items"
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


  describe "Fetch one merchant" do
    it "can get one poster by its id" do
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
end

  # it "can return the count" do
  #   merchant1 = Merchant.create!(name: "Brown and Sons")
  #   merchant2 = Merchant.create!(name: "Brown and Moms")
  #   merchant3 = Merchant.create!(name: "Brown and Dads")

  #   get "/api/v1/merchants?sorted=age"

  #   merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
  #   expect(response).to be_successful
  # end

  