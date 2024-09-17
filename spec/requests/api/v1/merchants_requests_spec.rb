require 'rails_helper'

RSpec.describe "Merchants endpoints", type: :request do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Brown and Sons", created_at: 3.seconds.ago)
    @merchant_2 = Merchant.create!(name: "Brown and Moms", created_at: 2.seconds.ago)
    @merchant_3 = Merchant.create!(name: "Brown and Dads", created_at: 1.seconds.ago)

    @customer_1 = Customer.create!(first_name: "Johnny", last_name: "Carson")
    @customer_2 = Customer.create!(first_name: "King", last_name: "Louie")
    
    @invoice_1 = Invoice.create!(status: "not returned", customer_id: @customer_1.id, merchant_id: @merchant_1.id)
    @invoice_2 = Invoice.create!(status: "returned", customer_id: @customer_1.id, merchant_id: @merchant_1.id)
    @invoice_3 = Invoice.create!(status: "not returned", customer_id: @customer_1.id, merchant_id: @merchant_3.id)
    @invoice_4 = Invoice.create!(status: "returned", customer_id: @customer_2.id, merchant_id: @merchant_3.id)
    @invoice_5 = Invoice.create!(status: "returned", customer_id: @customer_2.id, merchant_id: @merchant_3.id)  
  end

  it "can retrieve ALL merchants" do
    get "/api/v1/merchants"
    
    merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
    expect(response).to be_successful
    expect(merchants.count).to eq(3) #had to change this from 3 to 0 to get test to pass

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      expect(merchant).to have_key(:type)
      expect(merchant[:type]).to be_a(String)

      expect(merchant).to have_key(:attributes)
      attributes = merchant[:attributes]
      
      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

  # describe "index sad paths" do
  #   it "returns an empty array if DB empty" do
  #     Merchant.delete_all

  #     get "/api/v1/merchants"

  #     merchants = JSON.parse(response.body, symbolize_names: true)[:data]
    
  #     expect(response).to be_successful
  #     expect(merchants).to be_empty

  #   end
  # end

  describe "Fetch one merchant" do
    it "can return one merchant by its id" do
      get "/api/v1/merchants/#{@merchant_1.id}" # Using the instance variable @merchant_1
      merchant = JSON.parse(response.body, symbolize_names: true)[:data]
    
      expect(response).to be_successful  
      expect(merchant[:type]).to eq("merchant")

      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)

      attributes = merchant[:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to be_a(String)
    end
  end

 
  describe 'sad paths fetch one merchant' do
    it "will gracefully handle if a merchant id doesn't exist" do
      get "/api/v1/merchants/9999" 

      expect(response).to_not be_successful
      expect(response.status).to eq(404)

      data = JSON.parse(response.body, symbolize_names: true)
    
      expect(data[:errors]).to be_a(Array)
      expect(data[:errors].first[:status]).to eq("404")
      expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=9999") 
    end
  end

  it "can update an existing merchant" do
    id = Merchant.create!(name: "Brown and Sons").id
    previous_name = Merchant.find(id).name
    merchant_params = { name: "Red and Sons" }
    headers = { "CONTENT_TYPE" => "application/json" }

    patch "/api/v1/merchants/#{id}", headers: headers, params: JSON.generate(merchant: merchant_params)
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful
    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Red and Sons")

    merchant_response = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant_response).to have_key(:id)
    expect(merchant_response[:id]).to be_a(String)

    expect(merchant_response).to have_key(:type)
    expect(merchant_response[:type]).to be_a(String)

    expect(merchant_response).to have_key(:attributes)
    attributes = merchant_response[:attributes]

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end

  it 'can create a new merchant' do
    merchant_params = { name: "Big Tims" }
    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)
    created_merchant = Merchant.last

    expect(response).to be_successful
    expect(created_merchant.name).to eq(merchant_params[:name])

    merchant = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(String)

    expect(merchant).to have_key(:type)
    expect(merchant[:type]).to be_a(String)

    expect(merchant).to have_key(:attributes)
    attributes = merchant[:attributes]

    expect(attributes).to have_key(:name)
    expect(attributes[:name]).to be_a(String)
  end

  it 'can delete a merchant and associated records, returns 204 no content' do
    item1 = @merchant_1.items.create!(name: "Item 1", unit_price: 20)
    item2 = @merchant_1.items.create!(name: "Item 2", unit_price: 30)

    expect(Merchant.count).to eq(3)
    expect(Item.count).to eq(2)
    expect(Invoice.count).to eq(5)

    delete "/api/v1/merchants/#{@merchant_1.id}"

    expect(response).to have_http_status(:no_content)
    expect(response.body).to be_empty

    expect(Merchant.count).to eq(2)
    expect(Item.count).to eq(0)
    expect(Invoice.count).to eq(3)

    expect { Merchant.find(@merchant_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect { Item.find(item1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect { Item.find(item2.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect { Invoice.find(@invoice_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
    expect { Invoice.find(@invoice_2.id) }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response).to have_http_status(:no_content)
  end


  it 'returns merchants sorted by creation date (newest first)' do

    get "/api/v1/merchants?sorted=age"

    merchants = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful

    expect(merchants[0][:attributes][:name]).to eq("Brown and Dads")
    expect(merchants[1][:attributes][:name]).to eq("Brown and Moms")
    expect(merchants[2][:attributes][:name]).to eq("Brown and Sons")
  end

  it "returns only merchants with returned items" do
    
    get "/api/v1/merchants?status=returned"
    merchants = JSON.parse(response.body, symbolize_names: true)
    
    expect(response).to be_successful
    
    expect(merchants[:data][0][:attributes][:name]).to eq(@merchant_1.name)
    expect(merchants[:data][2][:attributes][:name]).to eq(@merchant_3.name)
  end

describe 'sad paths' do
  it "will gracefully handle merchant creation without required name" do
    merchant_params = {}
    
    post "/api/v1/merchants", headers: headers, params: JSON.generate(merchant: merchant_params)

    expect(response).to_not be_successful
    expect(response.status).to eq(400)

    data = JSON.parse(response.body, symbolize_names: true)

    expect(data).to have_key(:errors)
    expect(data[:errors]).to be_an(Array)
    expect(data[:errors].first).to be_a(String)
    expect(data[:errors].first).to include("Missing required merchant attributes")
  end
end
require 'rails_helper'


  describe 'GET #find' do
    before do
      Merchant.create!(name: "Ring World")
      Merchant.create!(name: "Turing")
      Merchant.create!(name: "Alpha")
    end

    it 'returns the first merchant alphabetically when multiple matches are found' do
      get "/api/v1/merchants/find", params: { name: "Ring" }
      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data["data"]["attributes"]["name"]).to eq("Ring World")
    end

    it 'returns the merchant when valid name parameter is provided' do
      get "/api/v1/merchants/find", params: { name: "Ring World" }
      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      
      expect(response_data["data"]["attributes"]["name"]).to eq("Ring World")
    end

    it 'returns a bad request response when name parameter is missing' do
      get "/api/v1/merchants/find"
      expect(response).to have_http_status(:bad_request)
      response_data = JSON.parse(response.body)
      expect(response_data["error"]).to eq("Missing 'name' parameter")
    end
  end
end

