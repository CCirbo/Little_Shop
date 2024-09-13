require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :invoices }
  end

  it 'returns merchants sorted by creation date (newest first)' do
    merchant_1 = Merchant.create!(name: "Merchant A", created_at: 2.days.ago)
    merchant_2 = Merchant.create!(name: "Merchant B", created_at: 1.day.ago)
    merchant_3 = Merchant.create!(name: "Merchant C", created_at: Time.now)

    expected = [merchant_3, merchant_2, merchant_1]

    expect(Merchant.sorted_by_age).to eq(expected) 
  end
end