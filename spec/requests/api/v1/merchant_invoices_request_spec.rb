require 'rails_helper'

RSpec.describe "Merchant Invoices API" do
  it "can send a list of invoices for a merchant based on status" do
    merchant = Merchant.create!(name: "Test Merchant")
    customer = Customer.create!(first_name: "Customer First", last_name: "Customer last")

    Invoice.create!(status: "shipped", merchant_id: merchant.id, customer_id: customer.id)
    Invoice.create!(status: "packaged", merchant_id: merchant.id, customer_id: customer.id)
    Invoice.create!(status: "returned", merchant_id: merchant.id, customer_id: customer.id)

    get "/api/v1/merchants/#{merchant.id}/invoices?status=shipped"
    
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(response).to be_successful

    invoices.each do |invoice|
      expect(invoice).to have_key(:id)
      expect(invoice[:id]).to be_an(String)

      expect(invoice).to have_key(:type)
      expect(invoice[:type]).to be_a(String)

      expect(invoice).to have_key(:attributes)
      attributes = invoice[:attributes]
      
      expect(attributes).to have_key(:status)
      expect(attributes[:status]).to be_a(String)
      expect(attributes[:status]).to eq("shipped") 

      expect(attributes).to have_key(:merchant_id)
      expect(attributes[:merchant_id]).to be_a(Integer)
      expect(attributes[:merchant_id]).to eq(merchant.id)
    end
  end

  it 'returns an empty array if no invoices with the given status are found' do
    merchant = Merchant.create!(name: "Test Merchant")
    customer = Customer.create!(first_name: "Customer First", last_name: "Customer last")

    get "/api/v1/merchants/#{merchant.id}/invoices?status=shipped"

    expect(response).to be_successful
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(invoices).to eq([])
  end

  it 'returns an error for invalid status' do
    merchant = Merchant.create!(name: "Test Merchant")
    customer = Customer.create!(first_name: "Customer First", last_name: "Customer last")

    get "/api/v1/merchants/#{merchant.id}/invoices?status=invalid_status"

    expect(response.status).to eq(400)
  end

  it 'returns all invoices for a merchant if no status is provided' do
    merchant = Merchant.create!(name: "Test Merchant")
    customer = Customer.create!(first_name: "Customer First", last_name: "Customer Last")

    invoice1 = Invoice.create!(status: "shipped", merchant_id: merchant.id, customer_id: customer.id)
    invoice2 = Invoice.create!(status: "packaged", merchant_id: merchant.id, customer_id: customer.id)
    invoice3 = Invoice.create!(status: "returned", merchant_id: merchant.id, customer_id: customer.id)

    get "/api/v1/merchants/#{merchant.id}/invoices"

    expect(response).to be_successful
    invoices = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(invoices.count).to eq(3)

    expect(invoices[0][:id].to_i).to eq(invoice1.id)
    expect(invoices[1][:id].to_i).to eq(invoice2.id)
    expect(invoices[2][:id].to_i).to eq(invoice3.id)
  end

  it 'returns a 404 error when merchant is not found' do
    get "/api/v1/merchants/9999/invoices"

    expect(response).to have_http_status(:not_found)
    
    error_response = JSON.parse(response.body, symbolize_names: true)

    expect(error_response).to have_key(:message)
    expect(error_response[:message]).to eq("your query could not be completed")

    expect(error_response).to have_key(:errors)
    expect(error_response[:errors]).to be_an(Array)

    error = error_response[:errors].first

    expect(error).to have_key(:status)
    expect(error[:status]).to eq("404")

    expect(error).to have_key(:title)
    expect(error[:title]).to eq("Couldn't find Merchant with 'id'=9999")
  end

end