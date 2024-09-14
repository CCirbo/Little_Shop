require 'rails_helper'

describe 'GET all invoices for mercahnt based on status' do
  describe 'GET /api/v1/merchants/:merchant_id/invoices' do
    it 'returns all invoices for a merchant with a given status' do
      merchant = create(:merchant)
      shipped_invoice = create(:invoice, merchant: merchant, status: 'shipped')
      packaged_invoice = create(:invoice, merchant: merchant, status: 'packaged')
      create(:invoice, merchant: merchant, status: 'returned')
  
      get "/api/v1/merchants/#{merchant.id}/invoices?status=shipped"
  
      expect(response).to be_successful
      invoices = JSON.parse(response.body, symbolize_names: true)[:data]
  
      expect(invoices).to be_an(Array)
      expect(invoices.length).to eq(1)
      expect(invoices.first[:attributes][:status]).to eq('shipped')
    end
  end
end


