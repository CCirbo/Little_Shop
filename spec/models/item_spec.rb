require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
  end

  describe '#class methods' do 
    before(:each) do
      @merchant = Merchant.create!(name: "Test Merchant")
      @item_1 = Item.create!(name: "Mouse", description: "Clicks", unit_price: 100.99, merchant: @merchant)
      @item_2 = Item.create!(name: "Keyboard", description: "Types", unit_price: 10.99, merchant: @merchant)
      @item_3 = Item.create!(name: "Pad", description: "Soft", unit_price: 120.99, merchant: @merchant)
      @item_4 = Item.create!(name: "Notebook", description: "Gets Written On", unit_price: 121.99, merchant: @merchant)
    end

    it 'returns all items sorted by price (Low to High)' do 
      expected = [@item_2, @item_1, @item_3, @item_4]
      expect(Item.sorted_by_price).to eq(expected)
    end

    it 'filters items by name' do
      expect(Item.filter_by_name("Mouse")).to eq([@item_1])
    end

    it 'filters items by min_price' do
      expect(Item.filter_by_min(100)).to eq([@item_1, @item_3, @item_4])
    end

    it 'filters items by max_price' do
      expect(Item.filter_by_max(100)).to eq([@item_2])
    end

    it 'raises an error when both name and price parameters are passed' do
      params = { name: "Mouse", min_price: 50 }
      expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "Cannot search by both name and price")
    end

    it 'raises an error when min_price is negative' do
      params = { min_price: -10 }
      expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "min_price must be a positive number")
    end

    it 'raises an error when max_price is negative' do
      params = { max_price: -5 }
      expect { Item.sort_and_filter(params) }.to raise_error(ArgumentError, "max_price must be a positive number")
    end
  end
end