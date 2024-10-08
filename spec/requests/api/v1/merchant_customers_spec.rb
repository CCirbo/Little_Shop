require 'rails_helper'

RSpec.describe "Merchants Customers API", type: :request do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Brown and Sons", created_at: 3.seconds.ago)
    @merchant_2 = Merchant.create!(name: "Brown and Moms", created_at: 2.seconds.ago)
    @merchant_3 = Merchant.create!(name: "Brown and Dads", created_at: 1.second.ago)
    @customer_1 = Customer.create!(first_name: "Johnny", last_name: "Carson")
    @customer_2 = Customer.create!(first_name: "King", last_name: "Louie")

    Invoice.create!(merchant: @merchant_1, customer: @customer_1, status: "shipped")
    Invoice.create!(merchant: @merchant_1, customer: @customer_2, status: "shipped")
    Invoice.create!(merchant: @merchant_3, customer: @customer_2, status: "shipped")
  end

  it "returns all customers for a given merchant" do
    get "/api/v1/merchants/#{@merchant_1.id}/customers"

    expect(response).to be_successful
    customers = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(customers.count).to eq(2)

    attributes = customers.find { |customer| customer[:id] == @customer_1.id.to_s }[:attributes]
    expect(attributes[:first_name]).to eq(@customer_1.first_name)
    expect(attributes[:last_name]).to eq(@customer_1.last_name)

    attributes = customers.find { |customer| customer[:id] == @customer_2.id.to_s }[:attributes]
    expect(attributes[:first_name]).to eq(@customer_2.first_name)
    expect(attributes[:last_name]).to eq(@customer_2.last_name)
  end

  it "returns all customers for a different merchant" do
    get "/api/v1/merchants/#{@merchant_3.id}/customers"

    expect(response).to be_successful
    customers = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(customers.count).to eq(1)

    attributes = customers.find { |customer| customer[:id] == @customer_2.id.to_s }[:attributes]
    expect(attributes[:first_name]).to eq(@customer_2.first_name)
    expect(attributes[:last_name]).to eq(@customer_2.last_name)
  end

  it "returns an empty array if the merchant has no customers" do
    get "/api/v1/merchants/#{@merchant_2.id}/customers"

    expect(response).to be_successful
    customers = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(customers).to eq([])
  end

  it "returns a 404 error if the merchant id does not exist" do
    get "/api/v1/merchants/999999/customers" 
  
    expect(response).to_not be_successful
    expect(response.status).to eq(404)
  
    data = JSON.parse(response.body, symbolize_names: true)
  
    expect(data[:errors]).to be_a(Array)
    expect(data[:errors].first[:status]).to eq("404")
    expect(data[:errors].first[:title]).to eq("Couldn't find Merchant with 'id'=999999")
  end
end