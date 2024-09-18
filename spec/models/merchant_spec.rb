require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  describe "Merchant Class Methods" do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Merchant A", created_at: 2.days.ago)
      @merchant_2 = Merchant.create!(name: "Merchant B", created_at: 1.day.ago)
      @merchant_3 = Merchant.create!(name: "Merchant C", created_at: Time.now)

      @customer_1 = Customer.create!(first_name: "Johnny", last_name: "Carson")
      
      @invoice_1 = Invoice.create!(status: "not returned", customer_id: @customer_1.id, merchant_id: @merchant_1.id)
      @invoice_2 = Invoice.create!(status: "returned", customer_id: @customer_1.id, merchant_id: @merchant_2.id)
      @invoice_3 = Invoice.create!(status: "returned", customer_id: @customer_1.id, merchant_id: @merchant_3.id)
    end

    it "retrieves all merchants" do
      expected = [@merchant_1, @merchant_2, @merchant_3]

      result = Merchant.sort_and_filter({})  

      expect(result).to eq(expected)
    end

    it "retrieves merchants sorted by creation date (newest first)" do
      expected = [@merchant_3, @merchant_2, @merchant_1]
      result = Merchant.sort_and_filter({sorted: "age"})
      expect(result).to eq(expected)
    end

    it "retrieves merchants whose invoices have a status of 'returned'" do
      expected = [@merchant_2, @merchant_3]
      result = Merchant.sort_and_filter({status: "returned"})
      expect(result).to eq(expected)
    end

    context "filter_by_name" do
      it "returns the 1st item in A-Z order with a case insensitive search" do
        result = Merchant.filter_by_name("meRcHa")
        expect(result.id).to eq(@merchant_1.id)
      end
      
      it "returns nil when no merchants match query in part or whole" do
        result = Merchant.filter_by_name("xxx")
        expect(result).to be_nil
      end
    end
  end
end